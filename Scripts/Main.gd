extends Spatial

var viewport = "/root/Main/ViewportContainer/MainView/"
var player = viewport + "Player/"
var gui = viewport + "GUI/"
var ground = viewport + "Ground/"
var fire = ground + "ObjectCampfire/"


func _process(_delta):
	if Input.is_action_just_pressed("ui_quit"):
		get_tree().quit()
