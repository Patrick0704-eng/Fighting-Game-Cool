extends CharacterBody2D

var standing_speed = 150.0
var crouching_speed = 75.0

var speed = standing_speed
var jump_velocity = -350.0

var gravity = 1000.0

var player = 1

var up = "up1"
var left = "left1"
var down = "down1"
var right = "right1"

var is_crouching = false

var animation_idle = "standing_idle"

@onready var standing_box = $standing_box
@onready var crouching_box = $crouching_box

@onready var animation_frames = $animation_frames

func _ready():
	if player == 2:
		up = "up2"
		left = "left2"
		down = "down2"
		right = "right2"

func _physics_process(delta):
	animation_frames.play(animation_idle)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_pressed(down) and is_on_floor():
		is_crouching = true
		speed = crouching_speed
		animation_idle = "crouching_idle"
		crouching_box.disabled = false
		standing_box.disabled = true
	elif Input.is_action_just_released(down) and is_on_floor():
		is_crouching = false
		speed = standing_speed
		animation_idle = "standing_idle"
		crouching_box.disabled = true
		standing_box.disabled = false
	
	if Input.is_action_pressed(up) and is_on_floor() and !is_crouching:
		velocity.y = jump_velocity
	
	var direction = Input.get_axis(left, right)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
