extends CanvasLayer

export var initial_tries = 3
export var initial_stage = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		start_game()

func _ready():
	$CenterContainer/VBoxContainer/Title/AnimationPlayer.play("bounce")


func start_game():
	Gamestate.tries = initial_tries
	Gamestate.stage = initial_stage
	get_tree().change_scene(Gamestate.get_stage())
