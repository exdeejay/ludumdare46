extends PanelContainer

const ItemRenderer = preload("res://Scenes/ItemRenderer.tscn")

onready var main = $"/root/Main"
onready var inventory = get_node(main.player).inventory
onready var contents = $MarginContainer/VBoxContainer/Contents
onready var item_list = $MarginContainer/VBoxContainer/Contents/ScrollContainer/HBoxContainer
onready var recipes = $MarginContainer/VBoxContainer/Recipes
onready var recipe_list = $MarginContainer/VBoxContainer/Recipes/ScrollContainer/VBoxContainer


func _ready():
	for panel in item_list.get_children():
		panel.rect_min_size = Vector2(panel.rect_size.x, panel.rect_size.x)
		panel.size_flags_horizontal = 0
	update_gui()
	contents.rect_min_size.y = item_list.get_children()[0].rect_size.x
	item_list.rect_min_size.y = item_list.get_children()[0].rect_size.x


func update_gui():
	var panels = item_list.get_children()
	for i in range(panels.size()):
		for node in panels[i].get_children():
			node.queue_free()
		if i >= 5:
			panels[i].queue_free()
	for node in recipe_list.get_children():
		node.queue_free()
	
	for i in range(inventory.items.size()):
		if i >= 5:
			var container = PanelContainer.new()
			container.rect_min_size = item_list.get_children()[0].rect_min_size
			item_list.add_child(container)
		var icon = create_item_icon(inventory.items[i], inventory.items[i].amount)
		item_list.get_children()[i].add_child(icon)
	
	for item in inventory.recipes:
		var button = Button.new()
		var container = HBoxContainer.new()
		container.size_flags_horizontal = SIZE_EXPAND_FILL
		var product_icon = create_item_icon(item, 1)
		product_icon.rect_min_size = Vector2.ONE * 128
		container.rect_min_size.y = product_icon.rect_min_size.y
		button.rect_min_size.y = product_icon.rect_min_size.y
		container.add_child(product_icon)
		for j in range(0, item.recipe.size(), 2):
			var component = item.recipe[j]
			var amount = item.recipe[j + 1]
			var component_icon = create_item_icon(component, amount)
			component_icon.rect_min_size = Vector2.ONE * 128
			container.add_child(component_icon)
		
		button.add_child(container)
		button.connect("pressed", self, "_recipe_button_click", [item])
		
		recipe_list.add_child(button)
	

func create_item_icon(item, amount = 1):
	var container = ViewportContainer.new()
	var renderer = ItemRenderer.instance()
	renderer.get_node("Item").add_child(item.model.instance())
	if amount > 1:
		renderer.get_node("Amount").text = String(amount)
	container.stretch = true
	container.add_child(renderer)
	return container


func _recipe_button_click(item):
	for i in range(0, item.recipe.size(), 2):
		var fulfilled = false
		for j in inventory.items:
			if j.get_script().get_path() == item.recipe[i].get_script().get_path():
				if j.amount >= item.recipe[i + 1]:
					fulfilled = true
					break
		if not fulfilled:
			return
	for i in range(0, item.recipe.size(), 2):
		var to_remove = item.recipe[i].duplicate()
		to_remove.amount = item.recipe[i + 1]
		inventory.remove_item(to_remove)
	inventory.add_item(item.duplicate())
