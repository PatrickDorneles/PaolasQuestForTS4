extends PickableItem

var collected = false

func _on_item_taken(entity):
	if collected: return
	
	entity.heal(1)
	$CollectedSFX.play()
	collected = true
	visible = false
	
	yield($CollectedSFX, "finished")
	queue_free()
