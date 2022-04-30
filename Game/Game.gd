extends Node2D

var players=[]
var next_turn=0
var num=0
func _ready():	
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var p_ysort=Persistent_nodes.get_node("YSort")
	for child in p_ysort.get_children():
		if child.is_in_group("Player"):
			num+=1
			players.append(child)
			
	$CanvasLayer/dice.hide()
	make_current(players[next_turn])	
	
	
			
			
func _player_disconnected(id):
	rpc("remove_player",id)


func _on_LeaveButton_pressed():
	Persistent_nodes.show_nodes()
	rpc("remove_player",Global.my_id)
	var p_ysort=Persistent_nodes.get_node("YSort")
	for child in p_ysort.get_children():
		if child.is_in_group("Net"):
			child.queue_free()	
	queue_free()		
	get_tree().change_scene("res://UI/Main.tscn")
	
signal player_left(x)	
sync func remove_player(id):
	num-=1
	next_turn-=1
	var p_ysort=Persistent_nodes.get_node("YSort")
	if p_ysort.has_node(str(id)):
		var p=p_ysort.get_node(str(id))
		emit_signal("player_left",p.username_get())
		players.erase(p)
		p_ysort.get_node(str(id)).username_text_instance.queue_free()
		p_ysort.get_node(str(id)).queue_free()	
			
		
func _on_dice_player_moved(x):
	yield(get_tree().create_timer(1.0),"timeout")
	var v=$TilesGrid.get_node(str(x)).get_task()
	if v!="":		
		rpc("make_current",Global.player_master)
		var rt= range(1,4)[randi()%range(1,4).size()]	
		var task="res://Tasks/Task"+str(rt)+"/Task"+str(rt)+".tscn"
		var t=load(task).instance()
		t.start_task(v)
		$TasksLayer.add_child(t)
		$TilesGrid.rpc("clean_up")
		t.connect("task_ended",self,"on_task_ended")
	else:	
		rpc("get_next_turn")
		make_current(players[next_turn])	

		
func on_task_ended(val):
	yield(get_tree().create_timer(1.0),"timeout")
	if val:
		$CanvasLayer/dice.player_win()		
	else:
		$CanvasLayer/dice.player_lose()		
	

func _on_dice_finish_player_turn():
	rpc("get_next_turn")
	make_current(players[next_turn])
		
sync func get_next_turn():
	next_turn=(next_turn+1)%num
	
		
func make_current(x):	
	var c=str(x)
	c=c.split(':');
	rpc("check_turn",c[0])			

sync func check_turn(x):
	if x==str(Global.my_id):
		$CanvasLayer/dice.show()
	else:
		$CanvasLayer/dice.hide()	



