extends MarginContainer

onready var modal = $Modal
var active_gui
onready var animation_player = $"/root/Main/AnimationPlayer"


func open_gui(gui):
	if active_gui != null:
		close_gui()
	modal.add_child(gui)
	active_gui = gui
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func close_gui():
	if active_gui != null:
		active_gui.queue_free()
		active_gui = null
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func game_over_screen():
	animation_player.connect("animation_finished", self, "_animation_finished")
	animation_player.play("death_wait")


func _animation_finished(anim_name):
	if anim_name == "death_wait":
		animation_player.disconnect("animation_finished", self, "_animation_finished")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
