extends GridContainer

var colors=["#c83838","#30bbff","#e5d813","#964afb"]

onready var player_board=preload("res://Game/Player_board.tscn")
# Called when the node enters the scene tree for the first time.
var players=[]
var scores=[]
func _on_Game_game_ready():
	var c=0
	var p_ysort=get_parent().get_parent().get_parent().get_node("YSort/Players")
	
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
			



func _on_Game_player_left(x,p):
	print("player x: ",x)
	print(scores,scores.size())
	var v=get_node(x)
	for i in range(scores.size()):
		if players[i]==p:
			players.remove(i)
			scores.remove(i)
			break
	remove_child(v)
	print(scores,scores.size())

sync func update_score():
	for x in range(scores.size()):
		print(x," : ",scores[x]," : ",players[x])
		scores[x].set_score(players[x].get_hp())

func _on_dice_finish_player_turn():
	rpc("update_score")
	
func _on_dice_player_moved(x):
	rpc("update_score")



	
