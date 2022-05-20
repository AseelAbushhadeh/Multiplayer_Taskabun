extends Control

func _ready():
	randomize()

signal dice_rolled
var r
func _on_Button_pressed():
	animate_dice()
	yield(self,"animation_over")
	emit_signal("dice_rolled")	

signal animation_over
func animate_dice():	
	$Button.hide()
	$Sprite.show()
	$Timer.start()
	while $Timer.time_left>0:
		r= range(1,7)[randi()%range(1,7).size()]
		$Sprite.texture=load("res://Assets/Dice/"+str(r)+".png")
		yield(get_tree().create_timer(.3),"timeout")
	emit_signal("animation_over")		
	
		
"""
func _on_Timer_timeout():
	emit_signal("animation_over")	"""


signal player_moved(x)
signal finish_player_turn

func _on_TilesGrid_tasks_placed():
	yield(get_tree().create_timer(.5),"timeout")
	var c=r
	var new_pos=Global.player_master.get_position()
	var x=new_pos.x
	var y=new_pos.y
	var right=Global.player_master.get_direction()
	var inc=Global.player_master.get_hp()
	inc=Global.player_master.get_hp()
	while r>0 and inc<100:		
		yield(get_tree().create_timer(.5),"timeout")
		r-=1
		if inc%10==0 and right:
			y-=400
			right=false
			Global.player_master.right=right
		elif inc%10==0 and not right:
			y-=400
			right=true
			Global.player_master.right=right
		elif not right:
			x-=400			
		elif right:
			x+=400	
		inc+=1	
		Global.player_master.update_position(Vector2(x,y))	
	Global.player_master.set_hp(inc)
	$Sprite.texture=load("res://Assets/Dice/corner.png")
	$Button.show()
	emit_signal("player_moved",inc)
	
	
	
func player_win():
	animate_dice()
	yield(self,"animation_over")
	$label.text=str(r)
	var c=r
	var new_pos=Global.player_master.get_position()
	var x=new_pos.x
	var y=new_pos.y
	var right=Global.player_master.get_direction()
	var inc=Global.player_master.get_hp()
	inc=Global.player_master.get_hp()
	while r>0 and inc<100:		
		yield(get_tree().create_timer(.5),"timeout")
		r-=1
		if inc%10==0 and right:
			y-=400
			right=false
			Global.player_master.right=right
		elif inc%10==0 and not right:
			y-=400
			right=true
			Global.player_master.right=right
		elif not right:
			x-=400			
		elif right:
			x+=400	
		inc+=1	
		Global.player_master.update_position(Vector2(x,y))	
	Global.player_master.set_hp(inc)
	$Button.show()
	$Sprite.texture=load("res://Assets/Dice/corner.png")
	emit_signal("finish_player_turn")
	
func player_lose():
	animate_dice()
	yield(self,"animation_over")
	$label.text=str(r)
	var c=r
	var new_pos=Global.player_master.get_position()
	var x=new_pos.x
	var y=new_pos.y
	var right=Global.player_master.get_direction()
	var inc=Global.player_master.get_hp()
	inc=Global.player_master.get_hp()
	
	Global.player_master.right=not right
	while r>0 and inc>1:
		yield(get_tree().create_timer(.5),"timeout")
		r-=1
		if inc%10==1 and not right:
			y+=400
			right=true
			Global.player_master.right=not right
		elif inc%10==1 and right:
			y+=400
			right=false
			Global.player_master.right=not right
		elif not right:
			x+=400			
		elif right:
			x-=400
		inc-=1	
		Global.player_master.update_position(Vector2(x,y))	
	Global.player_master.right= right	
	Global.player_master.set_hp(inc)
	$Sprite.texture=load("res://Assets/Dice/corner.png")
	$Button.show()
	emit_signal("finish_player_turn")	



