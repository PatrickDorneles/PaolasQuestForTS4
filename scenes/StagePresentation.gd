extends CanvasLayer

onready var stage_label = $CenterContainer/VBoxContainer/StageLabel
onready var try_label = $CenterContainer/VBoxContainer/TryNumbers

func _ready():
	stage_label.text = stage_label.text % (Gamestate.stage + 1)
	try_label.text = try_label.text % Gamestate.tries
	

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		go_to_stage()

func go_to_stage():
	get_tree().change_scene(Gamestate.get_stage())

func _on_Timer_timeout():
	go_to_stage()
