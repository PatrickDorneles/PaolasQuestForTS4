class_name PlayerStatus extends Node

const PlayerStates = preload('./PlayerStates.gd').VALUES

onready var player: Player = get_parent()
onready var hit_timer: Timer = $HitTimer

export var max_health_points: int
export var speed_ratio: float
export var speed_ratio_on_air: float
export var max_speed: int
export var jump_speed: int
export(PlayerStates) var state = PlayerStates.IDLE
export var alive: bool = true

var jumping: bool = false
var health_points: int

signal health_updated(health_points)
signal state_changed(new_state, old_state)

func _ready():
	health_points = max_health_points

func update_health(value: int):
	health_points = clamp(health_points+value, 0, max_health_points)
	
	emit_signal("health_updated", health_points)
	
	if(health_points <= 0):
		die()
		return
	
	# When beeing hit
	if(health_points > 0 and value < 0):
		set_state(PlayerStates.TAKING_DAMAGE)
		hit_timer.start()
		
		get_tree().paused = true
		player.forgiving_frame_timer.start()

func set_state(new_state: int):
	var old_state = state
	state = new_state
	emit_signal("state_changed", state, old_state)

func is_state(verification_state: int):
	return state == verification_state

func die():
	alive = false
	if $DeathTimer.time_left == 0: $DeathTimer.start()

func on_HitTimer_timeout():
	set_state(PlayerStates.IDLE)

func _on_DeathTimer_timeout():
	Gamestate.lost_try()
