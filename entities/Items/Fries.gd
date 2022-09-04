extends PickableItem


func _on_item_taken(entity):
	entity.heal(1)
