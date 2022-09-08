extends PickableItem

var collected = false

func _on_item_taken(player: Player):
	if collected: return
	
	collected = true
	player.inventory.add_coins(1)
	visible = false
	$CollectSFX.play()
	yield($CollectSFX, "finished")
	queue_free()
