extends Spatial

var model
var amount = 1
var overlay_showing = false

onready var main = $"/root/Main"
onready var player = get_node(main.player)


func _process(_delta):
	if player.raycast.is_colliding() and player.raycast.get_collider() != null:
		var collider = player.raycast.get_collider().get_parent()
		if collider == self:
			overlay(true)
			return
	overlay(false)


func overlay(create):
	if create and not overlay_showing:
		recurse_set_layer(get_children()[0], 1 | 2)
		overlay_showing = true
	elif not create and overlay_showing:
		recurse_set_layer(get_children()[0], 1)
		overlay_showing = false


func recurse_set_layer(mesh, layer):
	if mesh is MeshInstance:
		mesh.layers = layer
	for c in mesh.get_children():
		recurse_set_layer(c, layer)
