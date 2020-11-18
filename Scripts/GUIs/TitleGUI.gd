extends MarginContainer

onready var animation_player = $"/root/MainMenu/AnimationPlayer"


func _on_Start_pressed():
	animation_player.play("fade_out")


func _on_Fullscreen_pressed():
	if OS.window_fullscreen:
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true


func _on_Quit_pressed():
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene("res://Scenes/Main.tscn")
