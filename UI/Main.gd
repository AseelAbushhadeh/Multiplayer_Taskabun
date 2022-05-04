extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"





func _on_TouchScreenButton_pressed():
	get_tree().change_scene("res://Settings/Settings.tscn")


func _on_JoinGame_pressed():
	Global.instance_node(load("res://UI/JoinServer.tscn"), self)
	


func _on_CreateGame_pressed():
	get_tree().change_scene("res://UI/CreateServer.tscn")
