extends Control


func _on_start_pressed():
	if PlayerData.new_game == true:
		get_tree().change_scene_to_file("res://Rooms/Room 1.tscn")
	else:
		get_tree().change_scene_to_file("res://Rooms/test room.tscn")

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Rooms/Room 1.tscn")
	PlayerData.new_game == false

func _on_settings_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
