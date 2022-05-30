class_name PlayerStatus extends Node

const PlayerMovementStates = preload('./PlayerMovementStates.gd')

enum PlayerStates {
	DEAD = 0,
	ALIVE = 1
}

export var max_health_points: int
export var speed: int
export var max_speed: int
export var jump_speed: int
export(PlayerStates) var player_state = PlayerStates.ALIVE

var movement_state = 0
var jumping: bool = false
var health_points: int

signal hit_taken(actual_health)
signal state_changed(new_state)
signal movement_state_changed(new_state)

func _init():
	health_points = self.max_health_points

func take_hit(damage_amount: int):
	health_points -= damage_amount
	
	if(health_points > 0):
		emit_signal("hit_taken", health_points)
	
	if(health_points <= 0):
		player_state = PlayerStates.DEAD
		emit_signal("state_changed", player_state)

func set_movement_state(new_state: int):
	movement_state = new_state
	emit_signal("movement_state_changed", movement_state)

func is_movement_state(state: int):
	return movement_state == state

func connect_to_status(node):
	connect("hit_taken", node, "on_player_hit_taken")
	connect("state_changed", node, "on_player_state_changed")
	connect("movement_state_changed", node, "on_player_movement_state_changed")
