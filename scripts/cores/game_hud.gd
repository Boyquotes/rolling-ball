extends CanvasLayer


@onready var label_coins: Label = $Control/LabelCoins
@onready var label_advice: Label = $Control/LabelAdvice

@onready var label_stopwatch_minute: Label = $Control/HBoxContainerStopwatch/LabelMinute
@onready var label_stopwatch_second: Label = $Control/HBoxContainerStopwatch/LabelSecond

var timer_stop = false
var time_minute = 0
var time_second = 0


func _ready() -> void:
	label_advice.visible = false


func stop_timer():
	timer_stop = true


func set_advice(advice):
	label_advice.text = advice


func show_advice():
	label_advice.visible = true


func hide_advice():
	label_advice.visible = false


func _on_timer_timeout():
	if not timer_stop:
		if time_second == 59:
			time_minute += 1
			time_second = 0
		else:
			time_second += 1
		label_stopwatch_minute.text = "0" + str(time_minute) if time_minute < 10 else str(time_minute)
		label_stopwatch_second.text = "0" + str(time_second) if time_second < 10 else str(time_second)
