class_name Player extends KinematicBody2D

onready var controls = $PlayerControls
onready var status = $PlayerStatus

func _physics_process(delta: float):
	controls.apply_gravity()
	controls.await_input()
	move_and_slide(controls.motion, Vector2.UP)

func die():
	status.player_state = 0
