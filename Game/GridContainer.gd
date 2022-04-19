extends GridContainer

var colors=["#c83838","#30bbff","#e5d813"]

onready var player_board=preload("res://Game/Player_board.tscn")
# Called when the node enters the scene tree for the first time.
var players=[]
var scores=[]
func _ready():
	var c=0
	yield(get_tree().create_timer(.2),"timeout")
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
			players.append(child)
			var p=player_board.instance()
			var charecter=child.get_mychar()
			charecter="res://Assets/players/head"+charecter[25]+".png"
			p.set_image(charecter)			
			if Global.player_master==child:
				p.set_name(Global.player_master.get_my_name())
			else:	
				p.set_name(child.username_get())
			p.set_score(child.get_hp())
			#p.set_color(colors[c])
			add_child(p)
			scores.append(p)
			c+=1
			
			
func _process(delta):
	for x in range(scores.size()):
		scores[x].set_score(players[x].get_hp())
		
