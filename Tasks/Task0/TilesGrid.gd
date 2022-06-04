extends GridContainer


onready var Tile=preload("res://Tasks/Task0/tile.tscn")
func _ready():
	for x in range(100):
		var t=Tile.instance()	
		add_child(t)
