extends Node3D

#@onready var player: RigidBody3D = $Level/Ball
#@onready var initial_position: Vector3 = player.get("position")

var level_coins = 3


func _on_death_zone_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
