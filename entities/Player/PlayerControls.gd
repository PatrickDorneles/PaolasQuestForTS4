extends Node

const PlayerMovementStates = preload('./PlayerMovementStates.gd').VALUES

enum MovementDirection {
	RIGHT = 1,
	LEFT = -1,
	NULL = 0
}

onready var player: Player = get_parent()
onready var status: PlayerStatus = get_node("../PlayerStatus")
onready var animated_sprite: AnimatedSprite = get_node("../AnimatedSprite")

var motion: Vector2 = Vector2.ZERO

func await_input():
	await_movement()
	await_jump()

func await_jump():
	var can_jump = (
		not status.is_movement_state(PlayerMovementStates.JUMPING)
		and not status.is_movement_state(PlayerMovementStates.FALLING)
	)
	
	if can_jump and Input.is_action_just_pressed("player_jump"):
		motion.y = -status.jump_speed
		status.set_movement_state(PlayerMovementStates.JUMPING)

func await_movement():
	if(Input.is_action_pressed("player_move_left") and !Input.is_action_pressed("player_move_right")):
		motion.x = get_x_movement_value(MovementDirection.LEFT)
		animated_sprite.set_flip_h(true)
	elif(Input.is_action_pressed("player_move_right") and !Input.is_action_pressed("player_move_left")):
		motion.x = get_x_movement_value(MovementDirection.RIGHT)
		animated_sprite.set_flip_h(false)
	else:
		motion.x = get_x_movement_value(MovementDirection.NULL)

func get_x_movement_value(direction: int):
	var status = player.status
	var speed = status.speed
	var max_speed = status.max_speed
	
	if direction == 1:
		return clamp(motion.x + speed, 0, max_speed)
	
	if direction == -1:
		return clamp(motion.x - speed, -max_speed, 0)
	
	if direction == 0:
		var is_motion_x_positive = motion.x > 0
		var is_motion_x_negative = motion.x < 0
		
		if(is_motion_x_positive):
			return clamp(motion.x - speed, 0, max_speed)
		elif(is_motion_x_negative):
			return clamp(motion.x + speed, -max_speed, 0)
	
	return 0

func apply_gravity():
	if (not player.is_on_floor() 
		and motion.y > 0 
		and not status.is_movement_state(PlayerMovementStates.FALLING)):
			status.set_movement_state(PlayerMovementStates.FALLING)
		
	
	if player.is_on_ceiling() and status.is_movement_state(PlayerMovementStates.JUMPING):
		status.set_movement_state(PlayerMovementStates.FALLING)
		motion.y = 0
		pass
	
	if player.is_on_floor():
		if(motion.x == 0):
			status.set_movement_state(PlayerMovementStates.IDLE)
		else:
			status.set_movement_state(PlayerMovementStates.WALKING)
		motion.y = 0
		pass
	
	motion.y += GravityConstants.gravity_speed
