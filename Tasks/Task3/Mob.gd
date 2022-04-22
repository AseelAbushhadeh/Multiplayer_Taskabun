extends RigidBody2D

var min_speed=150
var max_speed=300

func _ready():
	$AnimatedSprite.play()
	var mobs_types=$AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation=mobs_types[randi() % mobs_types.size()]



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
