extends Control


func set_number(x):
	name=str(x)
	$Label.text=str(x)
	
func set_task(x):
	$Sprite.texture=load(x)	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


	
