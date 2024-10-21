extends CharacterBody2D

#Define the standing speed, crouching speed and jump velo of hon
var standing_speed = 50.0
var crouching_speed = 25.0
var jump_velocity = -350.0

#Set hon's speed to his standing speed by default
var speed = standing_speed

#Define the gravity
var gravity = 1000.0

#Set the player value to 1 by default
var player = 1

#Set the keybinds to player1's keybinds by default
var up = "up1"
var left = "left1"
var down = "down1"
var right = "right1"
var block = "block1"
var high_punch = "high_punch1"
var low_punch = "low_punch1"
var high_kick = "high_kick1"
var low_kick = "low_kick1"

#Define all action booleans, set to false by default
var is_crouching = false
var is_attacking = false
var is_walking = false
var is_jumping = false

#Set the idle animation to standing by default
var animation_idle = "standing_idle"

#Reference hon's hitbox
@onready var hit_box = $hit_box

#Reference the animations
@onready var animation_frames = $animation_frames
@onready var animation_player = $animation_player

func _ready():
	#Set the keybinds to player2's keybinds if player == 2
	if player == 2:
		up = "up2"
		left = "left2"
		down = "down2"
		right = "right2"
		block = "block2"
		high_punch = "high_punch2"
		low_punch = "low_punch2"
		high_kick = "high_kick2"
		low_kick = "low_kick2"

func _physics_process(delta):
	#Check if player is trying to low blow and if they can, then executes the move
	if is_crouching and Input.is_action_just_pressed(low_punch) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("crouching_low_punch")
		await get_tree().create_timer(0.9).timeout
		is_attacking = false
	#Checks if the standing walk animation should be played, then plays it
	elif is_walking and !is_crouching and is_on_floor() and !is_attacking:
		if velocity.x > 0:
			animation_player.play("standing_walk")
		if velocity.x < 0:
			animation_player.play_backwards("standing_walk")
	#Checks if the crouching walk animation should be played, then plays it
	elif is_walking and is_crouching and is_on_floor() and !is_attacking:
		if velocity.x > 0:
			animation_player.play("crouching_walk")
		if velocity.x < 0:
			animation_player.play_backwards("crouching_walk")
	#Checks if the idle animation should be played, then plays it
	elif is_on_floor() and !is_attacking:
		animation_player.play(animation_idle)
	
	#Handles gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	
	#Checks if the player wants to crouch and can crouch, then runs crouch funtionality
	if Input.is_action_pressed(down) and is_on_floor() and !is_attacking:
		is_crouching = true
		speed = crouching_speed
		animation_idle = "crouching_idle"
	else:
		is_crouching = false
		speed = standing_speed
		animation_idle = "standing_idle"
	
	#Checks if player wants to jump and can jump, then jumps
	if Input.is_action_pressed(up) and is_on_floor() and !is_crouching and !is_attacking:
		velocity.y = jump_velocity
	
	#Handles horizontal movement
	#Add acceleration over time when moving towards enemy to give aggressor the advantage
	var direction = Input.get_axis(left, right)
	if direction and !is_attacking: 
		velocity.x = direction * speed
		is_walking = true
	else:
		velocity.x = 0 #move_toward(velocity.x, 0, speed)
		is_walking = false
	
	#Moves and slides
	move_and_slide()
