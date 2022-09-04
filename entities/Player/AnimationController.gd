extends AnimationPlayer

onready var player: Player = get_parent()
onready var status: PlayerStatus = get_node("../PlayerStatus")
onready var animated_sprite: AnimatedSprite = get_node("../AnimatedSprite")

const PlayerStates = preload('./PlayerStates.gd').VALUES

const state_to_animation = {
	2: "walking",
	1: "jumping",
	0: "idle",
	-1: "start_falling",
	-2: "hit",
	-7: "death"
}

func _ready():
	animated_sprite.connect("animation_finished", self, "on_animation_finished")

func on_animation_finished():
	play("RESET")
	
	if animated_sprite.animation.begins_with("start_falling"):
		animated_sprite.play("falling")

func on_player_state_changed(new_state: int, _old_state: int):
	if not status.alive: return
	
	var animation_to_play = state_to_animation.get(new_state)
	animated_sprite.play(animation_to_play)
	
	if animation_to_play == "jumping":
		play("jump")
	
	
	if animation_to_play == "hit":
		play("hurt")
	

func animate_death():
	animated_sprite.play('death')
