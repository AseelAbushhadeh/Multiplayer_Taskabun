extends KinematicBody2D

const speed = 400
var right=true setget set_direction,get_direction
puppet var puppet_sprite_direction=false setget set_sprie_direction,get_sprie_direction
var initial_pos=0 setget set_init_pos,get_init_pos


	
func set_init_pos(x):
	initial_pos=x
func get_init_pos():
	return initial_pos

func get_sprie_direction():
	return puppet_sprite_direction	
	
func set_sprie_direction(x):
	puppet_sprite_direction=x
	if get_tree().has_network_peer():
		if not is_network_master():
			$Sprite.flip_h=not x
			right=x

func set_direction(x):
	right=x
	if get_tree().has_network_peer():
		if is_network_master():
			$Sprite.flip_h=not x
			rpc("puppet_sprie_direction",x)
	
func get_direction():
	if get_tree().has_network_peer():
		if not is_network_master():
			return puppet_sprite_direction
	return right

var hp = 1 setget set_hp,get_hp

var health = 10 setget set_health,get_health
func set_health(val):
	health=val
func get_health():
	return health	
	
var mychar="" setget set_mychar,get_mychar
var velocity = Vector2(0, 0)
var can_shoot = true
var is_reloading = false
var myOval="" setget set_myOval
#var location=Vector2(0,0) setget set_location

var username_text = load("res://Player/Username_text.tscn")
var username setget username_set,username_get
var username_text_instance = null

puppet var puppet_myOval="" setget puppet_myOval_set
puppet var puppet_hp = 1 setget puppet_hp_set
puppet var puppet_char = "" setget puppet_char_set
puppet var puppet_position = Vector2(0, 0) setget puppet_position_set
puppet var puppet_velocity = Vector2()
#puppet var puppet_rotation = 0
puppet var puppet_username = "" setget puppet_username_set


onready var tween = $Tween
onready var sprite = $Sprite 
onready var reload_timer = $Reload_timer
#onready var shoot_point = $Shoot_point
onready var hit_timer = $Hit_timer
var active=false
func _ready():
	set_process(false)
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	
	username_text_instance = Global.instance_node_at_location(username_text, Persistent_nodes, global_position)
	
	username_text_instance.player_following = self
	
	
	

	Global.alive_players.append(self)
	
	
	yield(get_tree(), "idle_frame")
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = self

onready var Sheeld=preload("res://Player/Player_sheeld.tscn")
var sheeld

sync func destroy_sheeld():
	for x in get_children():
		if x.is_in_group("sheeld"):
			x.queue_free()
	
	
func start_move(ac,val):
	if val==false:
		set_process(false)
		if get_tree().is_network_server():
			rpc("destroy_sheeld")	
	if val:	
		active=ac
		var sheeld=Sheeld.instance()
		sheeld.name="sheeld"
		sheeld= Global.instance_node_at_location(Sheeld, self, global_position)
		sheeld.player_following = self
		sheeld.set_texture(ac)	
		set_process(val)
		if ac:
			sheeld.connect("area_entered",self,"area_entered")
			
func area_entered():
	if get_tree().is_network_server():
		rpc("hit_by_damager")
	
signal player_damaged

sync func hit_by_damager():
	if active:
		health -= 1
		$Sprite.set("modulate",Color(5,5,5,1))
		emit_signal("player_damaged")
		hit_timer.start()
		
signal player_died	

func _process(delta: float) -> void:
	
	if health<1 :
		health=10
		active=false	
		set_process(false)
		emit_signal("player_died")
		
		
	if get_tree().has_network_peer():
		# and visible ,because if we are not visible means we're dead so we should not be able to shoot
		if is_network_master():
			if Input.is_action_pressed("right"):
				set_direction(true)
			elif Input.is_action_pressed("left"):
				set_direction(false)
			var x_input = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
			var y_input = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
			
			velocity = Vector2(x_input, y_input).normalized()
			
			move_and_slide(velocity * speed)
			
			
			
		else:
			if not tween.is_active():
				move_and_slide(puppet_velocity * speed)
				
	
	
				
	
		
func set_myOval(x):
	myOval=x
	if get_tree().has_network_peer():
		if is_network_master():
			$oval.texture=load(myOval)	
			rset("puppet_myOval", myOval)			

			
func puppet_myOval_set(new_value):
	puppet_myOval = new_value
	if get_tree().has_network_peer():
		if not is_network_master():		
			if puppet_myOval=="":
				$oval.hide()	
			else:	
				$oval.texture=load(puppet_myOval)
			myOval = puppet_myOval
			
			

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()

func set_hp(new_value):
	hp = new_value
	if get_tree().has_network_peer():
		#this means that we are the active player and we need to tell all the other players
		if is_network_master():
			rset("puppet_hp", hp)

			
func set_mychar(new_value):
	mychar = new_value
	if get_tree().has_network_peer():
		if is_network_master():
			$Sprite.texture=load(mychar)
			rset("puppet_char", mychar)
	
	
			
func get_mychar():
	return mychar	
	
func username_get():
	return puppet_username	
	
func get_hp():
	return hp	

func get_my_name():
	return username
	

	
		
func puppet_hp_set(new_value):
	puppet_hp = new_value	
	
	if get_tree().has_network_peer():
		if not is_network_master():
			hp = puppet_hp

func puppet_char_set(new_value):
	puppet_char = new_value
	if get_tree().has_network_peer():
		if not is_network_master():
			$Sprite.texture=load(puppet_char)
			mychar = puppet_char

func username_set(new_value) -> void:
	username = new_value
	if get_tree().has_network_peer():
		if is_network_master() and username_text_instance != null:
			username_text_instance.text = username
			rset("puppet_username", username)
			
		

			
func puppet_username_set(new_value) -> void:
	puppet_username = new_value
	if get_tree().has_network_peer():
		if not is_network_master() and username_text_instance != null:
			username_text_instance.text = puppet_username


func _network_peer_connected(id) -> void:
	rset_id(id, "puppet_username", username)
	rset_id(id, "puppet_char", mychar)
	rset_id(id, "puppet_myOval", myOval)


func _on_Network_tick_rate_timeout():
	if get_tree().has_network_peer():
		if is_network_master():
			rset_unreliable("puppet_position", global_position)
			rset_unreliable("puppet_velocity", velocity)
			rset_unreliable("puppet_sprite_direction", right)
			rset_unreliable("puppet_myOval",myOval)
			#rset_unreliable("puppet_rotation", rotation)
			
func get_position():
	return global_position			

sync func update_position(pos):
	global_position = pos
	puppet_position = pos
	


func _on_Hit_timer_timeout():
	$Sprite.set("modulate",Color(1,1,1,1))





sync func destroy() -> void:
	username_text_instance.visible = false
	visible = false
	$CollisionShape2D.disabled = true
	Global.alive_players.erase(self)
	
	if get_tree().has_network_peer():
		if is_network_master():
			Global.player_master = null



