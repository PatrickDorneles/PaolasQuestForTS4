extends PickableItem


func _on_item_taken(player: Player):
	player.inventory.add_coins(1)
