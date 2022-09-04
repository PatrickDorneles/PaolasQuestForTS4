class_name Player extends KinematicBody2D

const PlayerStates = preload('./PlayerStates.gd').VALUES

onready var controls = $PlayerControls
onready var status = $PlayerStatus
onready var inventory = $Inventory
onready var hit_timer = $PlayerStatus/HitTimer

onready var forgiving_frame_timer = $ForgivingFrameTimer

func _physics_process(_delta: float):
	if status.alive:
		controls.apply_gravity()
		controls.await_input()
	else:
		controls.motion = Vector2.ZERO
	
	move_and_slide(controls.motion, Vector2.UP)

func heal(amount: int):
	status.update_health(+amount)

func die():
	status.player_state = PlayerStates.IDLE

func damage(amount: int, knockback: int = 0):
	if hit_timer.time_left > 0: return
	
	status.update_health(-amount)
	
	if not status.alive:
		$AnimationPlayer.animate_death()
		$PhisycalCollision.set_deferred("disabled", true)
		return
	
	if(knockback > 0):
		controls.apply_knockback(knockback)

func throw_up(value: int):
	controls.motion.y = value * -1

func throw_back(value: int):
	controls.motion.x = value * controls.facing_direction * -1

func _on_Visibility_screen_exited():
	if status.health_points != 0:
		status.update_health(-status.max_health_points)

func _on_HitBoxArea_body_entered(body:Node) -> void:
	if(body is Enemy 
		and not status.is_state(PlayerStates.TAKING_DAMAGE)
		and not status.is_state(PlayerStates.DEAD)):
		body.queue_free()
		controls.jump()
		
		get_tree().paused = true
		forgiving_frame_timer.start()

func _on_ForgivingFrameTimer_timeout() -> void:
	get_tree().paused = false