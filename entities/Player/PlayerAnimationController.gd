extends Node

onready var player: Player = get_parent()
onready var status: PlayerStatus = get_node("../PlayerStatus")
onready var animated_sprite: AnimatedSprite = get_node("../AnimatedSprite")

const state_to_animation = {
	-1: "start_falling",
	0: "idle",
	1: "jumping",
	2: "walking"
}

func _ready():
	status.connect_to_status(self)
	animated_sprite.connect("animation_finished", self, "on_animation_finished")

func on_animation_finished():
	if animated_sprite.animation.begins_with("start_falling"):
		animated_sprite.play("falling")


func on_player_hit_taken():
	pass

func on_player_state_changed():
	pass

func on_player_movement_state_changed(new_state: int):
	var animation_to_play = state_to_animation.get(new_state)
	animated_sprite.play(animation_to_play)
