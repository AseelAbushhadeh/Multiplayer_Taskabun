extends Node2D
signal game_ready
var players=[]
var next_turn=0
var num=0
func _ready():	
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Net"):
			Persistent_nodes.remove_child(child)
			$YSort/Players.add_child(child)		
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	
	var p_ysort=$YSort/Players
	for child in p_ysort.get_children():
		if child.is_in_group("Player"):
			num+=1
			players.append(child)
			
	$CanvasLayer/dice.hide()
	make_current(players[next_turn])	
	emit_signal("game_ready")


func _server_disconnected():
	$CanvasLayer/Popup2.popup()
	yield(get_tree().create_timer(3),"timeout")
	queue_free()
	get_tree().change_scene("res://UI/Main.tscn")
		
		
func _player_disconnected(id):
	var p_ysort=$YSort/Players
	if p_ysort.has_node(str(id)):
		var p=p_ysort.get_node(str(id))
		players.erase(p)
		emit_signal("player_left",p.username_get(),p)
		p_ysort.get_node("username"+str(id)).queue_free()
		p_ysort.get_node(str(id)).queue_free()
		num-=1
		next_turn-=1
		next_turn=(next_turn+1)%num
		List_cleanup(players[next_turn])


	
func _on_LeaveButton_pressed():
	Persistent_nodes.show_nodes()	
	rpc("remove_player",Global.my_id)
	Network.reset_network_connection()
	Network._server_disconnected()
	queue_free()
	get_tree().change_scene("res://UI/Main.tscn")
	
signal player_left(x,p)	
remote func remove_player(id):
	var p_ysort=$YSort/Players
	if p_ysort.has_node(str(id)):
		var p=p_ysort.get_node(str(id))
		players.erase(p)
		emit_signal("player_left",p.username_get(),p)
		p_ysort.get_node("username"+str(id)).queue_free()
		p_ysort.get_node(str(id)).queue_free()
		num-=1
		next_turn-=1
		next_turn=(next_turn+1)%num
		List_cleanup(players[next_turn])
			
		
func List_cleanup(x):
	var c=str(x)
	c=c.split(':')
	if c[0]==str(Global.my_id):
		$CanvasLayer/dice.show()
	else:
		$CanvasLayer/dice.hide()
				
			
signal started_task
signal finished_task		
func _on_dice_player_moved(x):
	yield(get_tree().create_timer(1),"timeout")
	var nodetask=$TilesGrid.get_node(str(x))
	var v=nodetask.get_task()
	if v!="" and v!="snake":	
		rpc("make_current",Global.player_master)
		var rt= range(1,4)[randi()%range(1,4).size()]	
		var task="res://Tasks/Task"+str(rt)+"/Task"+str(rt)+".tscn"
		var t=load(task).instance()
		t.start_task(v)
		$TasksLayer.add_child(t)
		for child in get_children():
			if child.is_in_group("NotTask"):
				child.hide()
		#emit_signal("started_task")
		$TilesGrid.rpc("clean_up")
		t.connect("task_ended",self,"on_task_ended")
	elif v=="snake":
		rpc("get_next_turn")
		make_current(players[next_turn])	
	else:	
		rpc("get_next_turn")
		make_current(players[next_turn])	

		
func on_task_ended(val):
	emit_signal("finished_task")
	for child in get_children():
			if child.is_in_group("NotTask"):
				child.show()
	yield(get_tree().create_timer(1.0),"timeout")
	if val:
		$CanvasLayer/dice.player_win()		
	else:
		$CanvasLayer/dice.player_lose()		
	
remote func view_port_texture():
	pass
	
func _on_dice_finish_player_turn():
	rpc("get_next_turn")
	make_current(players[next_turn])
		
sync func get_next_turn():
	next_turn=(next_turn+1)%num
	
		
func make_current(x):	
	var c=str(x)
	c=c.split(':')
	rpc("check_turn",c[0])			

sync func check_turn(x):
	if x==str(Global.my_id):
		$CanvasLayer/dice.show()
	else:
		$CanvasLayer/dice.hide()	



