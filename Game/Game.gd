extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Tile=preload("res://Game/Tile.tscn")
func _ready():
	
	var c=100
	for x in range(100):
		var t=Tile.instance()
		if x<10 :
			t.set_number(100-x)
		elif x<20:
			t.set_number(81+(x-10))	
		elif x<30:
			t.set_number(100-x)	
		elif x<40:
			t.set_number(61+(x-30))	
		elif x<50:
			t.set_number(100-x)	
		elif x<60:
			t.set_number(41+(x-50))
		elif x<70:
			t.set_number(100-x)	
		elif x<80:
			t.set_number(21+(x-70))	
		elif x<90:
			t.set_number(100-x)	
		else:
			t.set_number(1+(x-90))	
		
		$GridContainer.add_child(t)
