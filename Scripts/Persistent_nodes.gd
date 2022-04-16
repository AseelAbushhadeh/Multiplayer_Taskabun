extends Node



sync func update_number_of_players(x):
	if x:
		Network.No_of_current_players+=1
	else:
		Network.No_of_current_players-=1
				
		


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
