extends Camera

const SHAKE_MODIFIER = 0.025


var initial_pos = translation

onready var player = $".."
onready var main = $"/root/Main"
onready var ground = get_node(main.ground)


func _process(_delta):
	translation = initial_pos
	if player.time_in_darkness > 0:
		var shake_vec =  Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1)
		var weight = clamp((player.time_in_darkness - 4) / (player.TIME_TIL_DEATH - 4), 0, 1)
		shake_vec *= SHAKE_MODIFIER * weight
		translate(shake_vec)
