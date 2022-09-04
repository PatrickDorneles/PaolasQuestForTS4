extends Node2D

onready var player: Player = get_node("Entities/Player")

export var stage: int

func _ready():
	Gamestate.set_stage(stage)
	
