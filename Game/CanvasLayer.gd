extends CanvasLayer




func _on_TasksLayer_task0_started(x):
	if x:
		for child in get_children():
			child.hide()
	else:
		for child in get_children():
			child.show()		
