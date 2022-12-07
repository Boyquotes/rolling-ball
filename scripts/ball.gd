extends RigidBody3D


@export var rolling_force = 30
@export var jump_impulse = 1500
@export var mouse_sensitivity = 0.005
@export var joystick_sensitivity = 0.025

@onready var camera: Marker3D = $CameraRig
@onready var game_hud = get_parent().get_parent().get_node("GameHUD")
@onready var bonus_hud = get_parent().get_parent().get_node("GameHUD/Control/Bonus")

@onready var debug_message_1 = get_parent().get_parent().get_node("GameHUD/Control/VBoxContainerDebug/LabelMessage1")
@onready var debug_message_2 = get_parent().get_parent().get_node("GameHUD/Control/VBoxContainerDebug/LabelMessage2")

var bonus_background: Texture2D = preload("res://assets/textures/bonus/bonus-background.png")
var bonus_jump: Texture2D = preload("res://assets/textures/bonus/bonus-jump.png")
var bonus_elevator: Texture2D = preload("res://assets/textures/bonus/bonus-elevator.png")

var coins
var action
var action_body
var able_to_move
var able_to_action
var able_to_brake


func _ready() -> void:
	coins = 0
	action = null
	action_body = null
	able_to_move = true
	able_to_action = false
	able_to_brake = true


func _physics_process(delta) -> void:
	_camera_follow()
	debug_message_1.text = "Action : " + str(action)
	debug_message_2.text = "Able to action : " + str(able_to_action)
#	var move_direction: Vector3 = Vector3.ZERO
#	move_direction.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
#	move_direction.z = Input.get_action_strength("player_backward") - Input.get_action_strength("player_forward")
#	move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y).normalized()
#
#	angular_velocity.x = move_direction.x * rolling_force
#	angular_velocity.z = move_direction.z * rolling_force

#	if Input.is_action_pressed("player_forward"):
#		move_direction.z -= rolling_force * delta
#	elif Input.is_action_pressed("player_backward"):
#		move_direction.z += rolling_force * delta
#	if Input.is_action_pressed("player_left"):
#		move_direction.x -= rolling_force * delta
#	elif Input.is_action_pressed("player_right"):
#		move_direction.x += rolling_force * delta
#	move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y).normalized()
#
#	angular_velocity.x = move_direction.x * rolling_force
#	angular_velocity.z = move_direction.z * rolling_force
	
	if able_to_move:
		if Input.is_action_pressed("player_forward"):
			angular_velocity.z -= Input.get_action_strength("player_forward") * rolling_force * delta
		elif Input.is_action_pressed("player_backward"):
			angular_velocity.z += Input.get_action_strength("player_backward") * rolling_force * delta
		if Input.is_action_pressed("player_left"):
			angular_velocity.x -= Input.get_action_strength("player_left") * rolling_force * delta
		elif Input.is_action_pressed("player_right"):
			angular_velocity.x += Input.get_action_strength("player_right") * rolling_force * delta

		if Input.is_action_pressed("camera_up"):
			camera.rotate(Vector3.BACK, Input.get_action_strength("camera_up") * joystick_sensitivity)
		if Input.is_action_pressed("camera_down"):
			camera.rotate(Vector3.FORWARD, Input.get_action_strength("camera_down") * joystick_sensitivity)
		if Input.is_action_pressed("camera_left"):
			camera.rotate(Vector3.UP, Input.get_action_strength("camera_left") * joystick_sensitivity)
		if Input.is_action_pressed("camera_right"):
			camera.rotate(Vector3.DOWN, Input.get_action_strength("camera_right") * joystick_sensitivity)
		camera.rotation.x = 0
		
		var is_on_floor = $CheckFloor.is_colliding()
		if Input.is_action_just_pressed("player_action") and is_on_floor and able_to_action:
			_action()
		
		if able_to_brake:
			if Input.is_action_pressed("player_brake") and is_on_floor:
				angular_velocity = Vector3.ZERO
		
		if Input.is_action_pressed("camera_reset"):
			camera.rotation = lerp(camera.rotation, Vector3.ZERO, .2)
	else:
		angular_velocity = Vector3.ZERO


func _camera_follow() -> void:
	var old_camera_position = $CameraRig.global_transform.origin
	var ball_position = global_transform.origin
	var new_camera_position = lerp(old_camera_position, ball_position, .2)
	$CameraRig.global_transform.origin = new_camera_position
	$CheckFloor.global_transform.origin = global_transform.origin


#func _input(event) -> void:
#	if event is InputEventMouseMotion:
#		rotate_y(-event.relative.x * mouse_sensitivity)
#		camera.rotate_y(-event.relative.y * mouse_sensitivity)
#		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func _action() -> void:
	if action == "jump":
		apply_central_impulse(Vector3.UP * jump_impulse)
	elif action == "elevator":
		if not action_body.has_been_moved:
			action_body.elevate()


func _on_area_3d_area_entered(area):
	if area.is_in_group("coin"):
		coins += 1
		var coins_count = "Coins : " + str(coins)
		get_parent().get_parent().get_node("GameHUD/Control/LabelCoins").set("text", coins_count)
		area.free()
	elif area.is_in_group("jump_zone"):
		able_to_action = true
		action = "jump"
		game_hud.set_advice("Press ACTION key to jump")
		game_hud.show_advice()
		bonus_hud.set_texture(bonus_jump)
	elif area.is_in_group("elevator"):
		able_to_action = true
		action = "elevator"
		action_body = area
		game_hud.set_advice("Press ACTION key to use the elevator")
		game_hud.show_advice()
		bonus_hud.set_texture(bonus_elevator)


func _on_area_3d_area_exited(area):
	if area.is_in_group("jump_zone"):
		able_to_action = false
		action = null
		game_hud.hide_advice()
		bonus_hud.set_texture(bonus_background)
	elif area.is_in_group("elevator"):
		able_to_action = false
		action = null
		action_body = null
		game_hud.hide_advice()
		bonus_hud.set_texture(bonus_background)


func _on_area_3d_body_entered(body):
	pass


func _on_area_3d_body_exited(body):
	pass
