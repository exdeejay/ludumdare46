extends Spatial

const ItemLog = preload("res://Scenes/Items/ItemLog.tscn")

export var logs_to_drop = 1
export var chops_to_fell = 3
var chops = 0


func chop():
	chops += 1
	if chops == chops_to_fell:
		var logs = ItemLog.instance()
		logs.amount = logs_to_drop
		get_node($"/root/Main".player).inventory.add_item(logs)
		queue_free()
