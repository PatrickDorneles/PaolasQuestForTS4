extends Enemy

export var hit_damage: int
export var hit_knockback: int
export var speed:int

func _ready():
	motion.x = -speed

func _physics_process(delta):
	if(not $SeeFloor.is_colliding()):
		flip()
	
	if($SeeWall.is_colliding()):
		flip()
	

func flip():
	$AnimatedSprite.set_flip_h(not $AnimatedSprite.flip_h)
	$SeeFloor.cast_to.x *= -1
	$SeeWall.cast_to.x *= -1
	motion.x *= -1

func _on_enter_hit_area(body):
	if body is Player:
		body.damage(hit_damage, hit_knockback)
