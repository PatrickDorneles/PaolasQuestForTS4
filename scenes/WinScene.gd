extends CanvasLayer

onready var animation_player: AnimationPlayer = get_node("./CenterContainer/Title/AnimationPlayer")

func _ready() -> void:
	animation_player.play("bounce")
