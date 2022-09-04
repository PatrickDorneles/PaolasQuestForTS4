extends Node

const PlayerStates = preload('./PlayerStates.gd').VALUES
const FacingDirection = preload('./FacingDirection.gd').VALUES

onready var player: Player = get_parent()
onready var status = get_node("../PlayerStatus")
onready var animated_sprite: AnimatedSprite = get_node("../AnimatedSprite")

export(FacingDirection) var facing_direction = FacingDirection.RIGHT
export(FacingDirection) var movement_direction = FacingDirection.NULL
var motion: Vector2 = Vector2.ZERO


# Awaiting Functions

func await_input():
	var is_player_dead = not status.alive
	
	if not is_player_dead:
		await_movement()
		await_jump()
	else:
		movement_direction = FacingDirection.NULL
	
	move()

func await_jump():
	var can_jump = (
		not status.is_state(PlayerStates.JUMPING)
		and not status.is_state(PlayerStates.FALLING)
		and not status.is_state(PlayerStates.TAKING_DAMAGE)
	)
	
	if can_jump and Input.is_action_just_pressed("player_jump"):
		
		if(Input.is_action_pressed("player_look_down")):
			jump_down()
			return
		
		jump()

func await_movement():
	var can_move = (
		not status.is_state(PlayerStates.TAKING_DAMAGE)
	)
	
	if(
		Input.is_action_pressed("player_move_left") 
		and !Input.is_action_pressed("player_move_right")
		and can_move):
		animated_sprite.set_flip_h(true)
		movement_direction = FacingDirection.LEFT
		facing_direction = FacingDirection.LEFT
		
	elif(
		Input.is_action_pressed("player_move_right")
		 and !Input.is_action_pressed("player_move_left")
		 and can_move):
		animated_sprite.set_flip_h(false)
		movement_direction = FacingDirection.RIGHT
		facing_direction = FacingDirection.RIGHT
	else:
		movement_direction = FacingDirection.NULL

func move():
	if(movement_direction == FacingDirection.LEFT):
		motion.x = get_x_movement_value(FacingDirection.LEFT)
	elif(movement_direction == FacingDirection.RIGHT):
		motion.x = get_x_movement_value(FacingDirection.RIGHT)
	else:
		motion.x = get_x_movement_value(FacingDirection.NULL)

func apply_gravity():
	
	if (not player.is_on_floor() 
		and motion.y > 0 
		and not status.is_state(PlayerStates.FALLING)
		and not status.is_state(PlayerStates.TAKING_DAMAGE)):
			status.set_state(PlayerStates.FALLING)
	
	if player.is_on_ceiling() and status.is_state(PlayerStates.JUMPING):
		status.set_state(PlayerStates.FALLING)
		motion.y = 0
		return
	
	if player.is_on_floor() and not status.is_state(PlayerStates.TAKING_DAMAGE):
		if(motion.x == 0):
			status.set_state(PlayerStates.IDLE)
		else:
			status.set_state(PlayerStates.WALKING)
	
	
	if(player.is_on_wall() 
		and not player.is_on_floor()
		and not status.is_state(PlayerStates.TAKING_DAMAGE)
		):
		motion.x = 0
	
	motion.x = clamp(motion.x, -status.max_speed, status.max_speed)
	
	motion = GravityUtils.apply_gravity(player, motion)


# Utility Functions

func get_x_movement_value(direction: int):
	var speed_ratio = status.speed_ratio if player.is_on_floor() else status.speed_ratio_on_air
	var max_speed = status.max_speed
	
	if direction == 1:
		return min(lerp(motion.x, max_speed, speed_ratio), max_speed)
	
	if direction == -1:
		return max(lerp(motion.x, -max_speed, speed_ratio), -max_speed)
	
	if direction == 0:
		
		var is_motion_x_positive = motion.x > 0
		var is_motion_x_negative = motion.x < 0
		
		var value = clamp(lerp(motion.x, 0, speed_ratio), -max_speed, max_speed)
		
		if is_motion_x_negative and motion.x > -5:
			return 0
		
		if is_motion_x_positive and motion.x < 5:
			return 0
		
		return value 
	
	return 0

# Action Funtions

func jump():
	status.set_state(PlayerStates.JUMPING)
	motion.y = -status.jump_speed

func jump_down():
	player.position.y += 1

func throw_up(value: int):
	motion.y = value * -1

func throw_back(value: int, direction = 0):
	motion.x = value * direction * -1

func apply_knockback(value, direction = 0):
	throw_up(min(value/2, 200))
	throw_back(value, direction)
