extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 12
const SENSITIVITY = 0.003

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 40

@onready var head = $"Head"
@onready var camera = $"Head/Camera3D"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

#TODO: velocity should be inertial while in air
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and is_on_floor():
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	elif direction and not is_on_floor():
		velocity.x += direction.x * SPEED * delta
		velocity.z += direction.z * SPEED * delta
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
		velocity.z = clamp(velocity.z, -SPEED, SPEED)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	print(velocity.x, ", ", velocity.z)

	move_and_slide()
