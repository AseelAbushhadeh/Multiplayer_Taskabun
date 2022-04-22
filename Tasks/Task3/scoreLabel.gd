extends CanvasLayer

signal start_game

func display_message(txt):
	$messageLaabel.text=txt
	$messageLaabel.show()
	$messageTimer.start()

func update_score(score):
	$scoreLabel.text=str(score)
	
func _on_Button_pressed():
	$Button.hide()
	emit_signal("start_game")

func show_game_over():
	display_message("Game Over")
	yield($messageTimer,"timeout")
	$messageLaabel.text="Dodge The Creeps"
	$messageLaabel.show()
	yield(get_tree().create_timer(1.0),"timeout")
	$Button.show()
	

func _on_messageTimer_timeout():
	$messageLaabel.hide()
