extends Node2D


func set_image(x):
	$Control/TextureRect.texture=load(x)
	
func set_name(x):
	$Control/name.text=x
	
func set_score(x):
	$Control/score.text=str(x)	

func set_color(x):
	$Control/ColorRect.color=x	



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
