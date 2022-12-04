extends CanvasLayer


@onready var label_coins: Label = $Control/LabelCoins
@onready var label_advice: Label = $Control/LabelAdvice


func _ready():
	label_advice.visible = false


func set_advice(advice):
	label_advice.text = advice


func show_advice():
	label_advice.visible = true


func hide_advice():
	label_advice.visible = false
