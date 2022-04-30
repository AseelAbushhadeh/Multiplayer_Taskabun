extends GridContainer
var easy=[]
var medium=[]
var hard=[]

onready var Tile=preload("res://Game/Tile.tscn")
func _ready():	
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
	rpc("lanuch_tasks",easy,medium,hard)
	rpc("assign_tasks")
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("tasks_placed")


sync func lanuch_tasks(e,m,h):
	easy=e
	medium=m
	hard=h
	
	

sync func assign_tasks():
	for i in easy:
		get_node(str(i)).set_task("res://Assets/World/TaskEasyGreen.png")
	for i in medium:
		get_node(str(i)).set_task("res://Assets/World/TaskMediumYellow.png")
	for i in hard:
		get_node(str(i)).set_task("res://Assets/World/TaskHardRed.png")		

sync func clean_up():
	for i in easy:
		get_node(str(i)).set_task("")
	for i in medium:
		get_node(str(i)).set_task("")	
	for i in hard:
		get_node(str(i)).set_task("")

func assign_lists():
	easy=generate_random_list(1,34)
	medium=generate_random_list(34,67)
	hard=generate_random_list(67,100)

func generate_random_list(x,y):
	var tiles_list=[]
	for i in range(15):
		var r= range(x,y)[randi()%range(x,y).size()]
		if tiles_list.find(r)==-1:
			tiles_list.append(r)
			
	return tiles_list		
