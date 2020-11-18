extends "Item.gd"

var dont_stack
var recipe = [preload("res://Scenes/Items/ItemStick.tscn").instance(), 2]

export var time_to_die = 30
var time_left = time_to_die
var light_index

onready var particles = $Particles
onready var light = $OmniLight
onready var light_preset = light.light_energy
onready var range_preset = light.omni_range


func _init():
	model = preload("res://Meshes/Torch.escn")


func _enter_tree():
	var main = $"/root/Main"
	var ground = get_node(main.ground)
	light_index = ground.lights.size()
	ground.lights.append($OmniLight)


func _exit_tree():
	var ground = get_node(main.ground)
	ground.lights.remove(light_index)
	light_index = null


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if player.inventory.get_held_item() == self:
				if player.raycast.is_colliding():
					var collider = player.raycast.get_collider().get_parent()
					if collider.is_in_group("fire"):
						var fire = collider
						if not fire.died:
							time_left = time_to_die


func _process(delta):
	if time_left < 0:
		if particles.emitting:
			particles.emitting = false
		return
	if not particles.emitting:
		particles.emitting = true
	time_left -= delta
	var weight = time_left / time_to_die
	light.light_energy = lerp(0, light_preset, weight)
	light.omni_range = lerp(0, range_preset, weight)


func duplicate(flags = 15):
	var new_item = .duplicate(flags)
	new_item.time_left = time_left
	return new_item
