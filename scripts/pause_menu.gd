extends CanvasLayer


func _ready():
	get_tree().paused = false
	set("visible", false)


func _input(event) -> void:
	if event.is_action_pressed("pause"):
		print("entered in")
		set("visible", !get_tree().paused)
		get_tree().paused = !get_tree().paused
		$VBoxContainer/ButtonResume.grab_focus()


func _on_button_resume_pressed():
	get_tree().paused = false
	set("visible", false)


func _on_button_options_pressed():
	pass


func _on_button_main_menu_pressed():
	get_tree().paused = false
	set("visible", false)
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
