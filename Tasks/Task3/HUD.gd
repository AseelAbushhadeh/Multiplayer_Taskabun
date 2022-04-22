extends CanvasLayer

signal start_game


func _ready():
	randomize()
	

func display_message(txt):
	$messageLaabel.text=txt
	$messageLaabel.show()
	$messageTimer.start()

func update_score(score):
	$scoreLabel.text=str(score)
	


func show_game_over():
	if $scoreLabel.text=="0":
		display_message("Congrats you won!")
	else :
		display_message("Sorry you lost!")	
	yield($messageTimer,"timeout")
	
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().change_scene("res://Tasks/Test_Main/main.tscn")

	

func _on_messageTimer_timeout():
	$messageLaabel.hide()


func _on_StartGameTimer_timeout():
	emit_signal("start_game")
