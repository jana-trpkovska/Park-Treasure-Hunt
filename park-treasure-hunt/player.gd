extends CharacterBody3D

@export var speed: float = 3.0
@export var jump_velocity: float = 3.0
@export var gravity: float = 9.8

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

var game_ended = false

# Define the boundaries of the map
var min_x = -13.0
var max_x = 15.0
var min_z = -13.0
var max_z = 15.0

func _ready() -> void:
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	if game_ended:
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get input direction
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	# Normalize direction to prevent faster diagonal movement
	input_dir = input_dir.normalized()

	# Rotate the input direction based on the twist pivot (horizontal rotation)
	var move_direction = twist_pivot.global_transform.basis * input_dir  # Rotate the direction vector

	# Move the player using the velocity and move_and_slide
	velocity.x = move_direction.x * speed
	velocity.z = move_direction.z * speed

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Apply the movement to the player character
	move_and_slide()
	
	# Clamp the player's position to the defined boundaries
	position.x = clamp(position.x, min_x, max_x)
	position.z = clamp(position.z, min_z, max_z)

	# Apply mouse look rotation
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	twist_pivot.rotate_y(twist_input)  # Rotate horizontally
	pitch_pivot.rotate_x(pitch_input)  # Rotate vertically
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-30), deg_to_rad(30))  # Limit pitch rotation
	twist_input = 0.0
	pitch_input = 0.0


# Handle mouse movement input for rotating the camera
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity  # Horizontal rotation (twist)
			pitch_input = -event.relative.y * mouse_sensitivity  # Vertical rotation (pitch)
