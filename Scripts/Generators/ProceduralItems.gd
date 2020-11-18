const ItemPage = preload("res://Scenes/Items/ItemPage.tscn")

var lore = preload("res://Scripts/Lore.gd").new()
var prefabs = [
	preload("res://Scenes/Items/ItemStick.tscn"),
	preload("res://Scenes/Items/ItemStone.tscn")
]


func generate(root, size, item_count):
	for _i in range(item_count):
		var item_to_gen = prefabs[randi() % prefabs.size()]
		var item_node = item_to_gen.instance()
		var pos = Vector3(
			rand_range(-0.5 * size, 0.5 * size),
			0,
			rand_range(-0.5 * size, 0.5 * size)
		)
		item_node.translation = pos
		item_node.rotate_y(deg2rad(rand_range(-180, 180)))
		item_node.scale = Vector3.ONE * 1.5
		root.add_child(item_node)
	
	for p in lore.pages:
		var page = ItemPage.instance()
		page.text = p.text
		page.recipe = p.recipe
		
		var theta = deg2rad(rand_range(-180, 180))
		var pos = Vector3(
			p.distance * cos(theta),
			0,
			p.distance * sin(theta))
		page.translation = pos
		root.add_child(page)
