extends Node2D
var active=false
var player=false
var playerx = load("res://Player/Player.tscn")
var current_location
var health=10
signal task_ended(x)
var duration=10
func _ready():
	current_location=1
	$CanvasLayer/counter.start_timer(duration)
	$CanvasLayer/Label.hide()
	add_players()
	get_parent().get_parent().get_node("YSort").free()
	#$Camera2D.make_current()
	
func set_values(p,ac,v):
	player=p
	active=ac	
	if v=="easy":
		duration=10
		health=10
	elif v=="medium":
		duration=15	
		health=7
	else:
		duration=20	
		health=3
		

func add_players():
	var parent=get_parent().get_parent().get_node("YSort/Players")
	for x in parent.get_children():
		parent.remove_child(x)
		var place=get_node("YSort/Players/Position2D" + str(current_location)).global_position
		get_node("YSort/Players").add_child(x)	
		if x.is_in_group("Player"):
			x.update_position(place )
			x.set_health(health)
			if x.name==str(player):
				x.start_move(true,true)
			else:
				x.start_move(false,true)
			x.connect("player_died",self,"_on_Players_end_player")		
		elif x.is_in_group("Net"):
			current_location+=1		
	
				
func _on_Players_end_player():
	rpc("Player_died")			


sync func Player_died():
	end_game(false,"Lost")
	
func _on_counter_timeIsDone():
	end_game(true,"Won")
	
func end_game(x,st):
	$music.stop()
	var msg="..."
	if Global.my_id==player:
		if x:
			$win.play()
			msg="Congrats you "+st+"!"
		else:
			$lose.play()
			msg="Sorry you "+st+"!"	
	else:
		msg="Player "+st+"!"	
	$CanvasLayer/Label.text=msg
	yield(get_tree().create_timer(.2),"timeout")
	$CanvasLayer/Label.show()
	yield(get_tree().create_timer(3),"timeout")
	$CanvasLayer/Label.hide()	
	return_players()
	emit_signal("task_ended",x)
	queue_free()

onready var ys=preload("res://Game/YSort.tscn")	
func return_players():
	var ys_ins=ys.instance()
	ys_ins.name="YSort"
	get_parent().get_parent().add_child(ys_ins)
	var parent=get_parent().get_parent().get_node("YSort/Players")
	var place=get_node("YSort/Players")
	for x in place.get_children():
		if x.is_in_group("Player"):
			x.start_move(false,false)
		if x.is_in_group("Net"):
			place.remove_child(x)
			parent.add_child(x)
			



