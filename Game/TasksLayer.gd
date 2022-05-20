extends CanvasLayer
onready var _viewport = get_viewport()
var loop=true

func _on_Game_started_task():
	loop=true
	rpc("show_texture",true)
	var t=TextureRect.new()
	t.rect_size=Vector2(300,100)
	t.rect_position=Vector2(60,300)
	#t.texture=load("res://Assets/glowing square.png")
	t.flip_v=true
	#print("add child")
	add_child(t)
	
	while loop:
		yield(get_tree().create_timer(.1),"timeout")
		
		t.texture=_viewport.get_texture()
		"""var image=Image.new()
		image=_viewport.get_texture().get_data()
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		var image2 = texture.get_data()
		var raw_data = image2.get_data()"""

		""#var rect = Rect2(Vector2(0,0),Vector2(900,500))
		#image.blit_rect(image, rect, Vector2(0,0))"""
		#rpc("set_texture",raw_data)
	t.free()	
	#rpc("show_texture",false)
	
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
	print("here")
	"""var image = Image.new()
	image.create_from_data(1980,1080,true,image.FORMAT_RGBA8,x)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	get_node("texture_rect").texture=texture"""
	var image = Image.new()
	var image_error = image.load_png_from_buffer(x)
	if image_error != OK:
	  push_error("An error occurred while trying to display the image.")

	var texture = ImageTexture.new()
	texture.create_from_image(image)

func _on_Game_finished_task():
	loop=false
	
	
