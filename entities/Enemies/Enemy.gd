class_name Enemy extends KinematicBody2D

var motion: Vector2 = Vector2.ZERO

export var tracked = false

func _physics_process(delta):
	apply_gravity()
	move_and_slide(motion, Vector2.UP)
	
	if tracked:
		print(motion)

func apply_gravity():
	motion = GravityUtils.apply_gravity(self, motion)

func die():
	pass