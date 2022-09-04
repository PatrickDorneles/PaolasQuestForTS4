extends PickableItem


func _on_item_taken(entity):
	Gamestate.stage_cleared()
