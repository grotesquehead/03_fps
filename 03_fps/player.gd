extends CharacterBody3D


const WALK_SPEED = 5.0
const RUN_SPEED = 9.0
const ACCELERATION = 15.0
const DECELERATION = 30.0
const JUMP_SPEED = 10.0
const GRAVITY = 50.0

var mouse_sensitivity = 0.5

@onready var camera: Camera3D = $Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast: RayCast3D = $RayCast3D


func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
        camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
        camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-90),deg_to_rad(90))


func _physics_process(delta):
    var input_direction = get_input_direction()
    var move_direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.z)).normalized()
    
    if move_direction:
        var speed = WALK_SPEED if not Input.is_action_pressed("run") else RUN_SPEED
        velocity.x = move_toward(velocity.x, move_direction.x * speed, ACCELERATION * delta)
        velocity.z = move_toward(velocity.z, move_direction.z * speed, ACCELERATION * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
        velocity.z = move_toward(velocity.z, 0, DECELERATION * delta) 
    
    if is_on_floor():
        if Input.is_action_just_pressed("jump"):
            velocity.y = JUMP_SPEED
    else:
        velocity.y -= GRAVITY * delta
    
    if Input.is_action_just_released("shoot") and !animation_player.is_playing():
        animation_player.play("shoot")
        var object = ray_cast.get_collider()
        if object and object.has_method("take_damage"):
            object.take_damage()
    
    move_and_slide()


func get_input_direction() -> Vector3:
    var input_direction = Vector3.ZERO
    input_direction.x = Input.get_axis("move_left", "move_right")
    input_direction.z = Input.get_axis("move_forward", "move_back")
    
    return input_direction
