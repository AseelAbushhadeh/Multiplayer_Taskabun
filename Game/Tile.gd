extends Control

var task="" setget set_task,get_task
func set_number(x):
	name=str(x)
	$Label.text=str(x)

func set_task(x):
	if x=="res://Assets/World/TaskEasyGreen.png":
		task="easy"
		$Sprite.texture=load(x)	
	elif x=="res://Assets/World/TaskHardRed.png":
		task="hard"
		$Sprite.texture=load(x)	
	elif x=="res://Assets/World/TaskMediumYellow.png":
		task="medium"
		$Sprite.texture=load(x)	
	elif x=="snake":
		task=x
		$Sprite.texture=load("")	
		return $Position2D.global_position
	else:
		task=""	
		$Sprite.texture=load(x)	

func get_task():
	return task		




	
