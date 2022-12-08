extends Area3D


@export var next_level_name = "level_1"
var CompletedLevelMenu = preload("res://scenes/menus/completed_level_menu.tscn")

@onready var game_hud = get_parent().get_parent().get_node("GameHUD")
@onready var time_minute = get_parent().get_parent().get_node("GameHUD/Control/HBoxContainerStopwatch/LabelMinute")
@onready var time_second = get_parent().get_parent().get_node("GameHUD/Control/HBoxContainerStopwatch/LabelSecond")


func _on_body_entered(body):
	if body.is_in_group("player"):
		var level_coins = get_parent().get_parent().level_coins
		var player_coins = body.coins
		if level_coins == player_coins:
			body.able_to_move = false
			game_hud.stop_timer()
			var completed_level_menu = CompletedLevelMenu.instantiate()
			completed_level_menu.set_next_level_name(next_level_name)
			completed_level_menu.set_time(time_minute.get("text"), time_second.get("text"))
			add_child(completed_level_menu)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			game_hud.set_advice("Coins collected : " + str(player_coins) + "/" + str(level_coins))
			game_hud.show_advice()


func _on_body_exited(body):
	if body.is_in_group("player"):
		game_hud.hide_advice()
