extends "Item.gd"

var dont_place
var dont_stack
var recipe = [
	preload("res://Scenes/Items/ItemStick.tscn").instance(), 1,
	preload("res://Scenes/Items/ItemStone.tscn").instance(), 2
]
var chopping = false

onready var axe_anim_player = $"Axe/Handle/AnimationPlayer"


func _init():
	model = preload("res://Meshes/Axe.escn")


func _physics_process(_delta):
	if chopping:
		if player.raycast.is_colliding() and weakref(player.raycast.get_collider()).get_ref():
			if player.raycast.get_collider().is_in_group("tree"):
				var tree = player.raycast.get_collider().get_parent().get_parent()
				tree.chop()
		chopping = false


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if player.inventory.get_held_item() == self and player.gui.active_gui == null:
				if not axe_anim_player.is_playing():
					axe_anim_player.play("swing")
					chopping = true
