extends Node2D

onready var player: Player = get_node("Entities/Player")


func _process(delta):
	if player.position.y > 1000:
		get_tree().quit()
