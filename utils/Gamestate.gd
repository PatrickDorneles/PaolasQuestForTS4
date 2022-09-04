extends Node

var stagePresentation = "res://scenes/StagePresentation.tscn"
var winScene = "res://scenes/WinScene.tscn"

var stagesDictionary = {
	0: "res://scenes/Stages/StageOne.tscn",
	1: "res://scenes/Stages/StageTwo.tscn",
}

var stage: int
var tries: int = 3

func set_stage(stage):
	self.stage = stage

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