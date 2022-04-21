extends Control

func _ready():
	randomize()

signal dice_rolled
var r
func _on_Button_pressed():
	r= range(1,7)[randi()%range(1,7).size()]
	$label.text=str(r)
	emit_signal("dice_rolled")
	
		
	


func _on_TilesGrid_tasks_placed():
	var c=r
	var new_pos=Global.player_master.get_position()
	var x=new_pos.x
	var y=new_pos.y
	var myx=Global.player_master.get_init_pos()

	var right=Global.player_master.get_direction()
	while r>0:
		yield(get_tree().create_timer(.5),"timeout")
		r-=1
		if (x+400)>4000-(400-myx) and right:
			y-=400
			right=false
			Global.player_master.right=right
		elif (x-400)<myx and not right:
			y-=400
			right=true
			Global.player_master.right=right
		elif not right:
			x-=400			
		elif right:
			x+=400	
		Global.player_master.update_position(Vector2(x,y))	
		
	var inc=Global.player_master.get_hp()
	Global.player_master.set_hp(c+inc)
