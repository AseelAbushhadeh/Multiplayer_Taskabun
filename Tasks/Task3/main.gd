extends Control


export (PackedScene) var mob_scene
export var score=5
var Background=preload("res://Assets/StartBackground/EntryBackground.tscn")
var min_speed
var max_speed
signal task_ready
func _ready():
	randomize()
	$Arrows.hide()
	emit_signal("task_ready")
	
	
func start_task(x):
	yield(self,"task_ready")
	randomize()
	$Arrows.hide()			
	if x=="easy":
		score=range(5,11)[randi()%range(5,11).size()]
		min_speed=150
		max_speed=300
	elif x=="medium":
		score=range(10,16)[randi()%range(10,16).size()]	
		min_speed=200
		max_speed=350
	else:
		score=range(16,30)[randi()%range(16,30).size()]	
		min_speed=250
		max_speed=400	
	new_game()	
	

func new_game():
	var background=Background.instance()
	add_child(background)
	$music.play()
	$HUD.update_score(score)
	get_tree().call_group("mobs","queue_free")
	$Player.start($startPosition.position)
	if OS.get_name()=="Android":
		$Arrows.show()
	$startTimer.start()
	$HUD.display_message("get ready...")
	yield($startTimer,"timeout")
	$LimitTimer.start(score)
	$scoreTimer.start()
	$MobTimer.start()
	
func game_over():
	$scoreTimer.stop()	
	$MobTimer.start()
	$HUD.show_game_over()
	$music.stop()
	if score>0:	
		$deathSound.play()
		yield(get_tree().create_timer(3.0),"timeout")
		queue_free()
	else:
		$win.play()
		$Player.queue_free()	
		yield(get_tree().create_timer(3.0),"timeout")
		queue_free()
	
	

func _on_MobTimer_timeout():
	var mob_spawn_location=$Path2D/PathFollow2D
	mob_spawn_location.unit_offset=randf()
	
	var mob=mob_scene.instance()
	mob.min_speed=min_speed
	mob.max_speed=max_speed
	add_child(mob)
	
	mob.position=mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation+ PI/2
	direction+=rand_range(-PI/4,PI/4)
	mob.rotation=direction
	
	var velocity=Vector2(range(min_speed,max_speed)[randi()%range(min_speed,max_speed).size()],0)
	mob.linear_velocity=velocity.rotated(direction)
	
	
	


func _on_scoreTimer_timeout():
	score-=1
	if score<0:
		game_over()
		$MobTimer.stop()
	else:	
		$HUD.update_score(score)
