extends Node3D


func _ready():
	pass


func _on_death_zone_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
