extends CharacterBody3D


const SPEED = 5.0
const JUMP_SPEED = 10.0
const GRAVITY = 50.0

var mouse_sensitivity = 0.5

@onready var camera: Camera3D = $Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
        camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
        camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))


func _physics_process(delta):
    var input_direction = get_input_direction()
    var move_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.z)).normalized()
    
    velocity.x = move_direction.x * SPEED
    velocity.z = move_direction.z * SPEED
    
    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = JUMP_SPEED
    else:
        velocity.y -= GRAVITY * delta
    
    if Input.is_action_just_released("shoot") and !animation_player.is_playing():
        animation_player.play("shoot")
    move_and_slide()


func get_input_direction() -> Vector3:
    var input_direction = Vector3.ZERO
    input_direction.x = Input.get_axis("move_left", "move_right")
    input_direction.z = Input.get_axis("move_forward", "move_back")
    return input_direction
