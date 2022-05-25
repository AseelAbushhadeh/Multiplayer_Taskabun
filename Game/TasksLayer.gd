extends CanvasLayer
signal task_finished(x)
var number=0
var duration=0
var hardness=0 
var cup_list=[]
var cup_list_next=[]
var length=0
var equation
func select_task(v):
	var rt= range(1,3)[randi()%range(1,3).size()]	
	var task="res://Tasks/Task"+str(rt)+"/Task"+str(rt)+".tscn"
	var t=load(task).instance()
	match rt:		
		1:
			generate_values_1(v)
			t.set_values(number,duration,hardness,cup_list,cup_list_next,true)
		2:
			generate_values_2(v)	
			t.set_values(duration,hardness,length,true)

	add_child(t)
	t.connect("task_ended",self,"on_task_ended")
	rpc("set_values",number,duration,hardness,cup_list,cup_list_next,length)
	rpc("start_task",rt)
	
var rng = RandomNumberGenerator.new()
func generate_values_1(x):
	cup_list=[]
	cup_list_next=[]
	number=range(2,5)[randi()%range(2,5).size()]				
	if x=="easy":
		duration=range(5,10)[randi()%range(5,10).size()]
		hardness=rng.randf_range(.7,2.5)
	elif x=="medium":
		duration=range(8,15)[randi()%range(8,15).size()]	
		hardness=rng.randf_range(.7,2.5)-.2
	else:
		duration=range(15,20)[randi()%range(15,20).size()]	
		hardness=rng.randf_range(.7,2.5)-.5
	var n=number
	for i in range(6):
		var r=range(1,n+1)[randi()%range(1,n+1).size()]	
		var pos=range(1,n+1)[randi()%range(1,n+1).size()]	
		if r==pos and r==1:
			pos+=1
		elif r==pos and r>1:
			pos-=1
		cup_list.append(r)	
		cup_list_next.append(pos)
		
func generate_values_2(x):				
	if x=="easy":
		hardness=0
	elif x=="medium":	
		hardness=1
	else:
		hardness=2
	length=range(2,4+hardness)[randi()%range(2,4+hardness).size()]	
	duration=(length*(length-hardness))
		
	
remote func set_values(n,d,h,s,c,l):
	number=n
	duration=d
	hardness=h
	cup_list=s
	cup_list_next=c
	length=l
				

remote func start_task(rt):
	var task="res://Tasks/Task"+str(rt)+"/Task"+str(rt)+".tscn"
	var t=load(task).instance()
	match rt:		
		1:
			t.set_values(number,duration,hardness,cup_list,cup_list_next,false)
		2:
			t.set_values(duration,hardness,length,false)	
	
	add_child(t)
	
func on_task_ended(val):
	emit_signal("task_finished",val)	


"""
onready var _viewport = get_viewport()
var loop=true

var broadcast_port = Network.DEFAULT_PORT
func _on_Game_started_task():
	loop=true
	rpc("show_texture",true)
	var socket_udp = PacketPeerUDP.new()
	socket_udp.set_broadcast_enabled(true)
	socket_udp.set_dest_address('255.255.255.255', broadcast_port)
	while loop:
		yield(get_tree().create_timer(.9),"timeout")
		var raw_data=get_viewport().get_texture().get_data()
		var packet_message = to_json(raw_data)
		var packet = packet_message.to_ascii()
		socket_udp.put_packet(raw_data)
		rpc("set_texture",raw_data)
		
	rpc("show_texture",false)
	
remote func show_texture(x):
	#$TextureRect.visible=x
	#print($TextureRect.visible)
	if x:
		var t=TextureRect.new()
		t.name="texture_rect"
		t.rect_size=Vector2(1920,1080)
		t.rect_position=Vector2(0,0)
		t.flip_v=true
		print("add child")
		add_child(t)
	else:
		get_node("texture_rect").free()	
	
remote func set_texture(x):	
	var socket_udp = PacketPeerUDP.new()
	var array_bytes = socket_udp.get_packet()
	var serverMessage = array_bytes.get_string_from_ascii()
	var gameInfo = parse_json(serverMessage)
	var t = ImageTexture.new()
	if(array_bytes!=null):
		print("not null")
	t.create_from_image(array_bytes)
	get_node("texture_rect").texture=t


func _on_Game_finished_task():
	loop=false"""
	
	
