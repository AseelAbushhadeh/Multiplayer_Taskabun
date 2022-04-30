extends YSort

func show_nodes():
	$ui.show()
	$Items.hide()


		

sync func move_to_ysort():
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Net"):
			remove_child(child)
			$YSort.add_child(child)
	$Items.show()		

