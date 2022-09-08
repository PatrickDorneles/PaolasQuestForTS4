extends StaticBody2D

func _ready() -> void:
	pass # Replace with function body.



func _on_HitBox_body_entered(body:Node) -> void:
	if(body is Player):
		body.damage(1, 1000)
