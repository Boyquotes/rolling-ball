extends Control


func _ready():
	$Panel/VBoxContainer/ButtonAdventure.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_button_adventure_pressed():
	pass


func _on_button_chill_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_button_options_pressed():
	pass


func _on_button_exit_pressed():
	get_tree().quit()
