extends Node2D

onready var player: Player = get_node("Entities/Player")
onready var background = $ParallaxBackground/Background

export var stage: int

func _ready():
	Gamestate.set_stage(stage)
	background.visible = true
	
