extends Node

var stagePresentation = "res://scenes/StagePresentation.tscn"
var winScene = "res://scenes/WinScene.tscn"

var stagesDictionary = {
	0: "res://scenes/Stages/Stage1.tscn",
	1: "res://scenes/Stages/Stage2.tscn",
	2: "res://scenes/Stages/Stage3.tscn",
}

var stage: int
var tries: int = 3

func set_stage(new_stage):
	self.stage = new_stage

func stage_cleared():
	stage += 1
	var new_stage = stagesDictionary.get(stage)
	
	if new_stage == null:
		win()
		return
	
	get_tree().change_scene(stagePresentation)

func get_stage():
	return stagesDictionary.get(stage)

func lost_try():
	tries -= 1
	
	if tries > 0: return get_tree().change_scene(stagePresentation)
	
	if tries == 0: print("Game Over")

func win():
	return get_tree().change_scene(winScene)