extends Area3D


@onready var animation: AnimationPlayer = $AnimationPlayer
var has_been_moved


func _ready() -> void:
	has_been_moved = false


func elevate():
	animation.play("movement")
	has_been_moved = true
