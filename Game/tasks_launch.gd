extends Node2D

var easy=[]
var medium=[]
var hard=[]

	

func assign_lists(e,m,h):
	#clean_up()
	easy=e
	medium=m
	hard=h
	print(e," m= ",m," h= ",h)
	#assign_tasks()

func clean_up():
	for i in easy:
		get_parent().get_node(str(i)).set_task("")
	for i in medium:
		get_parent().get_node(str(i)).set_task("")	
	for i in hard:
		get_parent().get_node(str(i)).set_task("")

func assign_tasks():
	for i in easy:
		get_parent().get_node(str(i)).set_task("res://Assets/World/TaskEasyGreen.png")
	for i in medium:
		get_parent().get_node(str(i)).set_task("res://Assets/World/TaskMediumYellow.png")
	for i in hard:
		get_parent().get_node(str(i)).set_task("res://Assets/World/TaskHardRed.png")		

