var noise
var cave_radius
var cave_distance
var cave_height


func _init(_noise = null):
	noise = _noise
	if noise == null:
		randomize()
		noise = OpenSimplexNoise.new()
		noise.seed = randi()


func generate(height, size, subdivs, generate_cave = false):
	var cave_radius_sq
	var cave_pos
	if generate_cave:
		var cave_theta = rand_range(-180, 180)
		cave_radius_sq = pow(cave_radius, 2)
		cave_pos = Vector2(cave_distance * cos(deg2rad(cave_theta)), cave_distance * sin(deg2rad(cave_theta)))
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(subdivs):
		for x in range(subdivs):
			var pos = Vector3(x * size / subdivs - size / 2, 0, z * size / subdivs - size / 2)
			pos.y = height * noise.get_noise_2d(pos.x, pos.z)
			if generate_cave:
				var dist_to_cave = Vector2(pos.x, pos.z).distance_squared_to(cave_pos)
				if dist_to_cave < cave_radius_sq:
					pos.y += cave_height * ((cave_radius_sq - dist_to_cave) / cave_radius_sq) + noise.get_noise_2d(pos.x * 32, pos.z * 32)
			st.add_uv(Vector2(x / (size - 1), z / (size - 1)))
			st.add_vertex(pos)
	for j in range(subdivs - 1):
		for i in range(subdivs - 1):
			st.add_index(j * subdivs + i)
			st.add_index(j * subdivs + i + 1)
			st.add_index((j + 1) * subdivs + i)
			
			st.add_index(j * subdivs + i + 1)
			st.add_index((j + 1) * subdivs + i + 1)
			st.add_index((j + 1) * subdivs + i)
	st.generate_normals()
	st.generate_tangents()
	return st.commit()
