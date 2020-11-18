extends MeshInstance

const ProceduralGround = preload("res://Scripts/Generators/ProceduralGround.gd")


export var size = 256
export var subdivs = 256
export (OpenSimplexNoise) var noise
export var height = 1

onready var fire = $ObjectCampfire
onready var camera = $Camera


func _init():
	height *= 0.5
	randomize()


func _ready():
	var ground_builder = ProceduralGround.new(noise)
	var material = mesh.surface_get_material(0)
	mesh = ground_builder.generate(height, size, subdivs)
	mesh.surface_set_material(0, material)
	fire.translation.y = height * noise.get_noise_2d(fire.translation.x, fire.translation.z)
	camera.translation.y = fire.translation.y + 0.5
