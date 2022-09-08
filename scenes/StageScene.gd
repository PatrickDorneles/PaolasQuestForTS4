extends Node2D

onready var player: Player = get_node("Entities/Player")
onready var background = $ParallaxBackground/Background

export var stage: int

func _ready():
	Gamestate.set_stage(stage)
	background.visible = true
	player.connect("died", self, "player_died")

func player_died():
	print("here")
	$DeathMusic.play()
	yield($DeathMusic, "finished")
	Gamestate.lost_try()
