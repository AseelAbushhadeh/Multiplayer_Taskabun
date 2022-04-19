extends Control

func _ready():
	randomize()


func _on_Button_pressed():
	var r= range(1,7)[randi()%range(1,7).size()]
	var c=r
	$label.text=str(r)
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
		elif (x-400)<myx and not right:
			y-=400
			right=true
		elif not right:
			x-=400			
		elif right:
			x+=400	
		Global.player_master.update_position(Vector2(x,y))	
		
	var inc=Global.player_master.get_hp()
	Global.player_master.set_hp(c+inc)	
	Global.player_master.set_direction(right)	
	
	
