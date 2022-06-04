extends GridContainer
var easy=[]
var medium=[]
var hard=[]
var snakes_e=[]
var snakes_m=[]
var snakes_h=[]

onready var Tile=preload("res://Game/Tile.tscn")
func _ready():
	randomize()	
	var c=100
	for x in range(100):
		var t=Tile.instance()
		if x<10 :
			t.set_number(100-x)
		elif x<20:
			t.set_number(81+(x-10))	
		elif x<30:
			t.set_number(100-x)	
		elif x<40:
			t.set_number(61+(x-30))	
		elif x<50:
			t.set_number(100-x)	
		elif x<60:
			t.set_number(41+(x-50))
		elif x<70:
			t.set_number(100-x)	
		elif x<80:
			t.set_number(21+(x-70))	
		elif x<90:
			t.set_number(100-x)	
		else:
			t.set_number(1+(x-90))	
		add_child(t)
		
signal tasks_placed	

func _on_dice_dice_rolled():
	rpc("clean_up")
	assign_lists()	
	rpc("lanuch_tasks",easy,medium,hard,snakes_e,snakes_m,snakes_h)
	rpc("assign_tasks")
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("tasks_placed")


sync func lanuch_tasks(e,m,h,s_e,s_m,s_h):
	easy=e
	medium=m
	hard=h
	snakes_e=s_e
	snakes_m=s_m
	snakes_h=s_h
	
	
	
onready var snake=preload("res://Game/snake.tscn")
sync func assign_tasks():
	for i in easy:
		get_node(str(i)).set_task("res://Assets/World/TaskEasyGreen.png")
	for i in medium:
		get_node(str(i)).set_task("res://Assets/World/TaskMediumYellow.png")
	for i in hard:
		get_node(str(i)).set_task("res://Assets/World/TaskHardRed.png")	
	var t=get_parent().get_node("YSort/snakes")		
	for i in snakes_e:
		var c=get_node(str(i))
		var loc=c.set_task("snake")	
		var sn=snake.instance()
		sn.set_level("easy")
		sn.name="snake"+str(i)
		sn.position=loc		
		t.add_child(sn)
	for i in snakes_m:
		var c=get_node(str(i))
		var loc=c.set_task("snake")	
		var sn=snake.instance()
		sn.set_level("medium")
		sn.name="snake"+str(i)
		sn.position=loc		
		t.add_child(sn)	
	for i in snakes_h:
		var c=get_node(str(i))
		var loc=c.set_task("snake")	
		var sn=snake.instance()
		sn.set_level("hard")
		sn.name="snake"+str(i)
		sn.position=loc		
		t.add_child(sn)	



sync func clean_up():
	for i in easy:
		get_node(str(i)).set_task("")
	for i in medium:
		get_node(str(i)).set_task("")	
	for i in hard:
		get_node(str(i)).set_task("")
	"""for i in get_parent().get_node("YSort/snakes").get_children():
		i.queue_free()
	for i in snakes_e:
		get_node(str(i)).set_task("")	
	for i in snakes_m:
		get_node(str(i)).set_task("")	
	for i in snakes_h:
		get_node(str(i)).set_task("")"""		

func assign_lists():
	easy=generate_random_list(1,34)
	snakes_e=generate_snakes_random_list(1,34,easy)
	medium=generate_random_list(34,67)
	snakes_m=generate_snakes_random_list(34,67,medium)
	hard=generate_random_list(67,100)
	snakes_h=generate_snakes_random_list(67,100,hard)
	

func generate_snakes_random_list(x,y,z):
	var tiles_list=[]
	for i in range(8):
		var r= range(x,y)[randi()%range(x,y).size()]
		if tiles_list.find(r)==-1 and z.find(r)==-1:
			tiles_list.append(r)
			
	return tiles_list
	
func generate_random_list(x,y):
	var tiles_list=[]
	for i in range(35):
		var r= range(x,y)[randi()%range(x,y).size()]
		if tiles_list.find(r)==-1:
			tiles_list.append(r)
			
	return tiles_list		



func _on_dice_player_moved(x):
	yield(get_tree().create_timer(1),"timeout")
	clean_up()
