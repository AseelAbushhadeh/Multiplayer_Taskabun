extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Tile=preload("res://Game/Tile.tscn")
func _ready():
	var c=100
	for x in range(100):
		var t=Tile.instance()
		t.set_number(100-x)
		$GridContainer.add_child(t)
