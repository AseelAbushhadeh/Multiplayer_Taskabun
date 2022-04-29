extends GridContainer

var colors=["#c83838","#30bbff","#e5d813","#964afb"]

onready var player_board=preload("res://Game/Player_board.tscn")
# Called when the node enters the scene tree for the first time.
var players=[]
var scores=[]
func _ready():
	var c=0
	yield(get_tree().create_timer(.2),"timeout")
	var p_ysort=Persistent_nodes.get_node("YSort")
	for child in p_ysort.get_children():
		if child.is_in_group("Player"):
			players.append(child)
			var p=player_board.instance()
			var charecter=child.get_mychar()
			charecter="res://Assets/players/head"+charecter[25]+".png"
			p.set_image(charecter)	
			var player_name		
			if Global.player_master==child:
				player_name	=Global.player_master.get_my_name()
				p.set_player_name(Global.player_master.get_my_name())
			else:	
				player_name=child.username_get()
				p.set_player_name(child.username_get())
			p.set_score(child.get_hp())
			p.set_color(colors[c])
			p.set_name(player_name)
			add_child(p)
			scores.append(p)
			c+=1
			



func _on_Game_player_left(x):
	print("player x: ",x)
	var v=get_node(x)
	remove_child(v)


func _on_dice_finish_player_turn():
	print("here")
	for x in range(scores.size()):
		scores[x].set_score(players[x].get_hp())


func _on_dice_player_moved(x):
	_on_dice_finish_player_turn()
