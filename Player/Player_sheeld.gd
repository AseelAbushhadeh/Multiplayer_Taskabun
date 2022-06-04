extends Node2D

var player_following = null
var sheeld = "" setget set_texture
var active
puppet var puppet_position setget set_puppet_position
func _ready():
	visible=false;
	if is_network_master():
		rset("puppet_position",global_position)
		

func set_puppet_position(x):
	puppet_position=x
	global_position=x

func _process(_delta: float) -> void:
	if player_following != null:
		global_position = player_following.global_position
		
		

func set_texture(val) -> void:
	if(val):
		$border.texture=load("res://Assets/redSheeld.png")
		$effect.texture=load("res://Assets/players/redSheeldEffect.png")
	visible=true	
	active=val
	
signal area_entered
func _on_area_area_entered(area):
	if area.is_in_group("player_damager") :
		emit_signal("area_entered")
	
