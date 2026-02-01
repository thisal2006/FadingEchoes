extends CharacterBody3D

# Speed settings
var speed = 5.0
var jump_force = 4.5
var gravity = 9.8

# Camera settings
var mouse_sensitivity = 0.002
var head : Node3D
var camera : Camera3D

func _ready():
	# Get camera and head nodes
	head = $Head
	camera = $Head/Camera3D
	
	# Hide mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		# Turn player left/right
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Tilt camera up/down
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		# Prevent camera from flipping
		head.rotation.x = clamp(head.rotation.x, -1.0, 1.0)

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Get input direction
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	# Make movement relative to where player is facing
	direction = direction.normalized()
	direction = direction.rotated(Vector3.UP, rotation.y)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
