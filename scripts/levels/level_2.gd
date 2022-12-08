extends Node3D


var level_coins = 1


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_death_zone_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
