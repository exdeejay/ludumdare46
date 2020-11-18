extends "Item.gd"

const PageContentsGUI = preload("res://Scenes/GUIs/PageContentsGUI.tscn")

var dont_stack
var has_opened = false
var text
var recipe


func _init():
	model = preload("res://Meshes/Page.escn")


func _input(event):
	if player.gui.active_gui == null:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == BUTTON_LEFT:
				if player.inventory.get_held_item() == self:
					var page_gui = PageContentsGUI.instance()
					page_gui.page_text = text
					player.gui.open_gui(page_gui)
					if not has_opened:
						has_opened = true
						for i in recipe:
							player.inventory.recipes.append(i.instance())


func duplicate(flags = 15):
	var new_item = .duplicate(flags)
	new_item.text = text
	new_item.recipe = recipe
	new_item.has_opened = has_opened
	return new_item
