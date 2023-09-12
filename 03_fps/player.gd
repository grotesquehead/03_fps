extends CharacterBody3D


const SPEED = 7.0
const JUMP_SPEED = 10.0
const GRAVITY = 50.0


func _physics_process(delta):
    var input_direction = get_input_direction()
    
    velocity.x = input_direction.x * SPEED
    velocity.z = input_direction.z * SPEED
    velocity.y -= GRAVITY * delta
    
    if is_on_floor() and Input.is_action_just_pressed("jump"):
        velocity.y = JUMP_SPEED
    
    move_and_slide()


func get_input_direction() -> Vector3:
    var input_direction = Vector3.ZERO
    input_direction.x = Input.get_axis("move_left", "move_right")
    input_direction.z = Input.get_axis("move_forward", "move_back")
    return input_direction
