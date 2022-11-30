extends RigidBody3D


@export var rolling_force = 30
@export var jump_impulse = 1500
@export var look_sensitivity = 0.005
@onready var camera: Marker3D = $CameraRig

func _ready() -> void:
	pass


func _physics_process(delta) -> void:
	_camera_follow()
	
	if Input.is_action_pressed("player_forward"):
		angular_velocity.z -= Input.get_action_strength("player_forward") * rolling_force * delta
	elif Input.is_action_pressed("player_backward"):
		angular_velocity.z += Input.get_action_strength("player_backward") * rolling_force * delta
	if Input.is_action_pressed("player_left"):
		angular_velocity.x -= Input.get_action_strength("player_left") * rolling_force * delta
	elif Input.is_action_pressed("player_right"):
		angular_velocity.x += Input.get_action_strength("player_right") * rolling_force * delta

	print(Input.get_action_strength("player_forward"))
	print(Input.get_action_strength("player_backward"))
	
	var is_on_floor = $CheckFloor.is_colliding()
	if Input.is_action_just_pressed("player_jump") and is_on_floor:
		apply_central_impulse(Vector3.UP * jump_impulse)
	
	if Input.is_action_pressed("player_brake") and is_on_floor:
		angular_velocity = Vector3(0, 0, 0)


func _camera_follow() -> void:
	var old_cameera_position = $CameraRig.global_transform.origin
	var ball_position = global_transform.origin
	var new_camera_position = lerp(old_cameera_position, ball_position, .2)
	$CameraRig.global_transform.origin = new_camera_position
	$CheckFloor.global_transform.origin = global_transform.origin


#func _input(event) -> void:
#	if event is InputEventMouseMotion:
#		rotate_y(-event.relative.x * look_sensitivity)
#		camera.rotate_y(-event.relative.y * look_sensitivity)
#		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
