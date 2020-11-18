extends MeshInstance

const ProceduralGround = preload("res://Scripts/Generators/ProceduralGround.gd")


export var size = 256
export var subdivs = 256
export (OpenSimplexNoise) var noise
export var height = 1

export var cave_height = 5
export var cave_radius = 10
export var cave_distance = 60

var lights = []

onready var main = $"/root/Main"
onready var player = get_node(main.player)
onready var fire = $ObjectCampfire
onready var fire_light = $ObjectCampfire/BaseLight


func _init():
	height *= 0.5
	randomize()


func _ready():
	var ground_builder = ProceduralGround.new(noise)
	ground_builder.cave_height = cave_height
	ground_builder.cave_radius = cave_radius
	ground_builder.cave_distance = cave_distance
	var material = mesh.surface_get_material(0)
	mesh = ground_builder.generate(height, size, subdivs, true)
	mesh.surface_set_material(0, material)
	
	create_trimesh_collision()
	
	lights.append(fire_light)
	fire.translation.y = height * noise.get_noise_2d(fire.translation.x, fire.translation.z)
	player.translation.y = height * noise.get_noise_2d(player.translation.x, player.translation.z)



