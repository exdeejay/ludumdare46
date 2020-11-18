extends Spatial

export var time_to_die = 120
var time_left = time_to_die
var died = false

var main
var fire_gui

onready var particles = $Particles
onready var base_light = $BaseLight
onready var base_light_preset = base_light.light_energy
onready var base_light_range = base_light.omni_range
onready var tail_light = $AnimationPlayer/TailLight
onready var tail_light_preset = tail_light.light_energy
onready var tail_light_range = tail_light.omni_range


func _ready():
	main = $"/root/Main"
	fire_gui = get_node(main.gui + "Side/FireHeight")


func _process(delta):
	if time_left <= 0:
		died = true
		if particles.emitting:
			particles.emitting = false
		return
	if not particles.emitting:
		particles.emitting = true
	time_left -= delta
	var weight = time_left / time_to_die
	weight = clamp(weight, 0, 1.25)
	base_light.light_energy = lerp(0, base_light_preset, weight)
	tail_light.light_energy = lerp(0, tail_light_preset, weight)
	base_light.omni_range = lerp(0, base_light_range, weight)
	tail_light.omni_range = lerp(0, tail_light_range, weight)
	fire_gui.value = weight
