extends Node2D

var players=[]
var next_turn=0
func _ready():
	var num=0
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
			num+=1
			players.append(child)

	
	
		
func _on_dice_player_moved(x):
	yield(get_tree().create_timer(1.0),"timeout")
	var v=$TilesGrid.get_node(str(x)).get_task()
	if v!="":
		var random_task= range(1,4)[randi()%range(1,4).size()]
		var task="res://Tasks/Task"+str(3)+"/main.tscn"
		var t=load(task).instance()
		t.start_task(v)
		$TasksLayer.add_child(t)
