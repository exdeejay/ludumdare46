extends KinematicBody

const Inventory = preload("res://Scripts/Inventory.gd")
const InventoryGUI = preload("res://Scenes/GUIs/InventoryGUI.tscn")

const TIME_TIL_DEATH = 10

const GRAVITY = 9.8
const SPEED = 5
const JUMP_SPEED = 5
const SENSITIVITY = 0.25
const REACH = 2


var time_in_darkness = 0
var dead = false

var dir = Vector3()
var velocity = Vector3()
var on_floor = false
var jumping = false
var sprinting = false
var rot_x = 0
var rot_y = 0


onready var main = $"/root/Main"

onready var gui = get_node(main.gui)
onready var ground = get_node(main.ground)
onready var fire = get_node(main.fire)

onready var inventory = $Inventory
onready var remote_transform = $RemoteTransform
onready var camera = $Camera
onready var raycast = $Camera/RayCast
onready var sound = $Camera/AudioStreamPlayer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	raycast.cast_to.z *= REACH
	raycast.add_exception(self)



func _process(delta):
	if dead:
		return
	
	jumping = false
	sprinting = false
	remote_transform.transform = camera.transform
	
	if Input.is_action_pressed("ui_cancel"):
		gui.close_gui()
	if Input.is_action_pressed("ui_select") and on_floor:
		velocity.y = JUMP_SPEED
		jumping = true
	if Input.is_action_pressed("sprint"):
		sprinting = true
	if Input.is_action_just_pressed("ui_inventory"):
		if gui.active_gui == null:
			gui.open_gui(InventoryGUI.instance())
		else:
			gui.close_gui()
	
	
	dir = Vector2()
	if Input.is_action_pressed("ui_up"):
		dir.y += 1
	if Input.is_action_pressed("ui_down"):
		dir.y -= 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	dir = dir.normalized()
	
	if raycast.is_colliding() and raycast.get_collider() != null:
		var collider = raycast.get_collider().get_parent()
		if collider.is_in_group("item"):
			pass
	
	var in_darkness = true
	for light in ground.lights:
		if global_transform.origin.distance_squared_to(light.global_transform.origin) < pow(light.omni_range, 2):
			in_darkness = false
			break
	if in_darkness:
		if not sound.playing:
			sound.play()
		time_in_darkness += delta
		if time_in_darkness >= TIME_TIL_DEATH:
			game_over()
	else:
		if sound.playing:
			sound.stop()
		time_in_darkness = 0


func _physics_process(delta):
	if dead:
		return
	
	var accel = -transform.basis.z * dir.y + transform.basis.x * dir.x
	accel = accel * SPEED
	if sprinting:
		accel *= 1.5
	accel.y = 0
	velocity.x = accel.x
	velocity.z = accel.z
	velocity.y -= GRAVITY * delta
	
	var collision = move_and_collide(velocity * delta, true, true, true)
	on_floor = false
	for _i in range(4):
		if on_floor:
			velocity.y = 0
		if collision == null:
			break
		var normal = collision.normal
		if abs(normal.dot(Vector3.UP)) > cos(deg2rad(25)) and not jumping:
			on_floor = true
			velocity.y = 0
		else:
			normal.y = 0
			normal = normal.normalized()
		velocity -= normal.dot(velocity) * normal
		collision = move_and_collide(velocity * delta, true, true, true)
	collision = move_and_collide(velocity * delta)


func _input(event):
	if dead:
		return
	
	if gui.modal.get_children().size() > 0:
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rot_x -= event.relative.y * SENSITIVITY
		rot_y -= event.relative.x * SENSITIVITY
		
		if rot_x > 90:
			rot_x = 90
		elif rot_x < -90:
			rot_x = -90
		
		transform.basis = Basis()
		rotate_y(deg2rad(rot_y))
		camera.transform.basis = Basis()
		camera.rotate_x(deg2rad(rot_x))
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				inventory.next_item()
			elif event.button_index == BUTTON_WHEEL_DOWN:
				inventory.prev_item()
			elif event.button_index == BUTTON_LEFT:
				if raycast.is_colliding():
					var collider = raycast.get_collider()
					handle_left_click(collider.get_parent())
			elif event.button_index == BUTTON_RIGHT:
				if raycast.is_colliding():
					var collider = raycast.get_collider()
					handle_right_click(collider.get_parent())
	if event is InputEventKey:
		if event.is_pressed():
			if event.scancode == KEY_1:
				inventory.set_item(0)
			elif event.scancode == KEY_2:
				inventory.set_item(1)
			elif event.scancode == KEY_3:
				inventory.set_item(2)
			elif event.scancode == KEY_4:
				inventory.set_item(3)
			elif event.scancode == KEY_5:
				inventory.set_item(4)
			elif event.scancode == KEY_6:
				inventory.set_item(5)
			elif event.scancode == KEY_7:
				inventory.set_item(6)
			elif event.scancode == KEY_8:
				inventory.set_item(7)
			elif event.scancode == KEY_9:
				inventory.set_item(8)
			elif event.scancode == KEY_0:
				inventory.set_item(9)


func handle_left_click(clicked):
	if clicked.is_in_group("item"):
		var item = clicked
		item.get_parent().remove_child(item)
		item.transform = Transform()
		inventory.add_item(item)
	if clicked.is_in_group("fire"):
		var fire = clicked
		if not fire.died:
			var held_item = inventory.get_held_item()
			if held_item != null and "fuel" in held_item:
				fire.time_left += held_item.fuel
				var subtract_item = held_item.duplicate()
				subtract_item.amount = 1
				inventory.remove_item(subtract_item)


func handle_right_click(clicked):
	if clicked.is_in_group("ground"):
		var item = inventory.get_held_item()
		if item != null and not "dont_place" in item:
			var ground_item = item.duplicate()
			ground_item.amount = 1
			inventory.remove_item(ground_item)
			
			var ground = clicked
			ground_item.transform = Transform()
			ground_item.translation = raycast.get_collision_point()
			ground_item.translation.y += 0.1
			ground_item.rotate_y(deg2rad(rand_range(-180, 180)))
			ground_item.scale = Vector3.ONE * 2
			ground.add_child(ground_item)


func game_over():
	dead = true
	gui.close_gui()
	gui.game_over_screen()
