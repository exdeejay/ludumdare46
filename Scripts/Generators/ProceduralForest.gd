const ObjectTree = preload("res://Scenes/Objects/ObjectTree.tscn")


func generate(root, num_trees, min_radius, max_radius, shorten):
	for _i in range(num_trees):
		var r = (max_radius - min_radius) * sqrt(randf()) + min_radius
		var theta = rand_range(0, 2 * PI)
		var tree = ObjectTree.instance()
		tree.translation.x = r * cos(theta)
		tree.translation.z = r * sin(theta)
		tree.rotate_y(rand_range(0, 2 * PI))
		tree.scale.y *= 1 - randf() * shorten
		root.add_child(tree)
