extends Spatial

const ProceduralForest = preload("res://Scripts/Generators/ProceduralForest.gd")

export var num_trees = 4096
export var min_radius = 4
export var max_radius = 128
export var shorten = 0.1

onready var ground = $".."


func _ready():
	ground.noise.seed = randi()
	var forest_builder = ProceduralForest.new()
	forest_builder.generate(self, num_trees, min_radius, max_radius, shorten)
	for tree in get_children():
		tree.translation.y = ground.height * ground.noise.get_noise_2d(tree.translation.x, tree.translation.z)
