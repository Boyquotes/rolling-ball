extends CanvasLayer


var next_level_name


func _ready() -> void:
	$VBoxContainer/VBoxContainerButton/ButtonNextLevel.grab_focus()


func set_next_level_name(level_name):
	next_level_name = level_name


func _on_button_next_level_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/" + next_level_name + ".tscn")


func _on_button_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
