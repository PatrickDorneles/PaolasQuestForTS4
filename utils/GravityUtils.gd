extends Node

var gravity_speed = 10

func apply_gravity(body: KinematicBody2D, motion: Vector2) -> Vector2:
	motion.y += gravity_speed
	
	if body.is_on_floor() and motion.y >= 0:
		motion.y = 0
	
	return motion
