extends Node

var recipes = [preload("res://Scenes/Items/ItemTorch.tscn").instance()]

var items = []
var held_index = -1
var gui_update_needed = false


onready var main = $"/root/Main"

onready var gui = get_node(main.gui)
onready var held_item_icon = gui.get_node("Side/HeldItemIcon")
onready var item_renderer = held_item_icon.get_node("ItemRenderer")
onready var item_renderer_node = item_renderer.get_node("Item")
onready var item_renderer_amount = item_renderer.get_node("Amount")

onready var hand = $"../Camera/Hand"


func _ready():
	set_item(held_index)


func _process(_delta):
	if gui_update_needed and gui.active_gui != null:
		gui.active_gui.update_gui()
		gui_update_needed = false
	item_renderer_amount.text = ""
	if items.size() > 0:
		if held_index >= 0 and held_index < items.size():
			if items[held_index].amount > 1:
				item_renderer_amount.text = String(items[held_index].amount)


func get_held_item():
	var held_items = hand.get_children()
	if held_items.size() == 0:
		return null
	else:
		return held_items[0]


func add_item(item):
	gui_update_needed = true
	if not "dont_stack" in item:
		for i in items:
			if i.get_script().get_path() == item.get_script().get_path():
				i.amount += item.amount
				item.queue_free()
				return
	items.append(item)


func remove_item(item):
	gui_update_needed = true
	for i in range(items.size()):
		if items[i].get_script().get_path() == item.get_script().get_path():
			items[i].amount -= item.amount
			if items[i].amount <= 0:
				items.remove(i)
				if held_index == i:
					set_item(0)
			break


func set_item(index):
	gui_update_needed = true
	for i in hand.get_children():
		hand.remove_child(i)
	for i in item_renderer_node.get_children():
		i.queue_free()
	if items.size() == 0 or index < 0 or index >= items.size():
		held_index = -1
		return
	
	hand.add_child(items[index])
	held_index = index
	
	var clone = items[index].model.instance()
	item_renderer_node.add_child(clone)


func next_item():
	if items.size() != 0:
		set_item((held_index + 1) % items.size())


func prev_item():
	if held_index < 1:
		held_index = items.size()
	set_item(held_index - 1)
