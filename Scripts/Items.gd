extends Spatial

const ProceduralItems = preload("res://Scripts/Generators/ProceduralItems.gd")

export var item_count = 4096

onready var ground = $".."


func _ready():
	var items_generator = ProceduralItems.new()
	items_generator.generate(self, ground.size, item_count)
	for i in get_children():
		i.translation.y = ground.height * ground.noise.get_noise_2d(i.translation.x, i.translation.z) + 0.1
