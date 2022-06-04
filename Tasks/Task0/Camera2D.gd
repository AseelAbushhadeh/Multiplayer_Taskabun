extends Camera2D



var target_player = null

func _process(delta: float) -> void:

	if Global.player_master != null:
		global_position = lerp(global_position, Global.player_master.global_position, delta * 10)
	
