class_name PickableItem extends Node2D


func _on_item_taken(entity):
	pass

func _on_item_touched(body: Node):
	if(body is Player):
		_on_item_taken(body)
