extends Control

var page_text

onready var page_text_node = $MarginContainer/PageText


func _ready():
	update_gui()


func update_gui():
	page_text_node.text = page_text
