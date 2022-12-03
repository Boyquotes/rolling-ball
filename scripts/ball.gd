extends RigidBody3D


@export var rolling_force = 30
@export var jump_impulse = 1500
@export var mouse_sensitivity = 0.005
@export var joystick_sensitivity = 0.025

@onready var camera: Marker3D = $CameraRig
@onready var game_hud = get_parent().get_parent().get_node("GameHUD")

var coins
var able_to_move
var able_to_jump
var able_to_brake


func _ready() -> void:
	coins = 0
	able_to_move = true
	able_to_jump = false
	able_to_brake = true


func _physics_process(delta) -> void:
	_camera_follow()
#	var move_direction: Vector3 = Vector3.ZERO
#	move_direction.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
#	move_direction.z = Input.get_action_strength("player_backward") - Input.get_action_strength("player_forward")
#	move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y).normalized()
#
#	angular_velocity.x = move_direction.x * rolling_force * delta
#	angular_velocity.z = move_direction.z * rolling_force * delta
#
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
		if Input.is_action_just_pressed("player_action") and is_on_floor and able_to_jump:
			apply_central_impulse(Vector3.UP * jump_impulse)
		
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


func _on_area_3d_area_entered(area):
	if area.is_in_group("coin"):
		coins += 1
		var coins_count = "Coins : " + str(coins)
		get_parent().get_parent().get_node("GameHUD/Control/LabelCoins").set("text", coins_count)
		area.free()
	elif area.is_in_group("jump_zone"):
		able_to_jump = true
		game_hud.set_advice("Press ACTION key to jump")
		game_hud.show_advice()


func _on_area_3d_area_exited(area):
	if area.is_in_group("jump_zone"):
		able_to_jump = false
		game_hud.hide_advice()
