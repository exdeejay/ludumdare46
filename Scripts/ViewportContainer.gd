extends ViewportContainer

onready var main = $"/root/Main"
onready var main_view = get_node(main.viewport)
onready var overlay_view = get_node(main.player + "Camera/OverlayViewport")


func _ready():
	material.set_shader_param("overlay_viewport", overlay_view.get_texture())
	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")
	_root_viewport_size_changed()


func _root_viewport_size_changed():
	var new_size = get_viewport().get_visible_rect().size
	main_view.size = new_size
	overlay_view.size = new_size
	rect_size = new_size
