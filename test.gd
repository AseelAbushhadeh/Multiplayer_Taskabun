extends Control


onready var c=[$Position2D1,$Position2D2,$Position2D3,$Position2D4,$Position2D5,$Position2D6]
# Called when the node enters the scene tree for the first time.
var r

func _on_Button_pressed():
	r= range(0,6)[randi()%range(0,6).size()]
	print(r)
	
	$KinematicBody2D.move_and_slide(c[r].position)
