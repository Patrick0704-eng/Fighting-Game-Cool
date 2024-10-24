extends CharacterBody2D

#Define the hon's different speeds
var flying_speed = 150.0
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
var high = "high1"
var low = "low1"
var unique = "unique1"

#Define all action booleans, set to false by default
var is_crouching = false
var is_attacking = false
var is_walking = false
var is_jumping = false
var is_jump_high

#Define a variable to see whether or not the player is flipped
var is_flipped = false

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
		high = "high2"
		low = "low2"
		unique = "unique2"

func _physics_process(delta):
	#Flip the player if they are player 2
	if player == 2:
		animation_frames.flip_h = true
		is_flipped = true
	#Check if the player can fly kick, then plays the animation and sets fly kick variables to true
	if Input.is_action_just_pressed(high) and !is_on_floor() and !is_attacking:
		is_attacking = true
		is_jump_high = true
		animation_player.play("jump_high")
	#Check if player is trying and can standing low attack, then attacks
	elif !is_crouching and Input.is_action_just_pressed(low) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("stand_low")
		await get_tree().create_timer(0.6).timeout
		is_attacking = false
	#Check if player is trying to low blow and if they can, then executes the move
	elif is_crouching and Input.is_action_just_pressed(low) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("crouch_low")
		await get_tree().create_timer(0.9).timeout
		is_attacking = false
	#Checks if the standing walk animation should be played, then plays it based on velocity direction and is_flipped bool
	elif is_walking and !is_crouching and is_on_floor() and !is_attacking:
		if !is_flipped:
			if velocity.x > 0:
				animation_player.play("stand_walk")
			elif velocity.x < 0:
				animation_player.play_backwards("stand_walk")
		else:
			if velocity.x < 0:
				animation_player.play("stand_walk")
			elif velocity.x > 0:
				animation_player.play_backwards("stand_walk")
	#Checks if the crouching walk animation should be played, then plays it based on velocity direction and is_flipped bool
	elif is_walking and is_crouching and is_on_floor() and !is_attacking:
		if !is_flipped:
			if velocity.x > 0:
				animation_player.play("crouch_walk")
			if velocity.x < 0:
				animation_player.play_backwards("crouch_walk")
		else:
			if velocity.x < 0:
				animation_player.play("crouch_walk")
			if velocity.x > 0:
				animation_player.play_backwards("crouch_walk")
	#Checks if the idle animation should be played, then plays it
	elif is_on_floor() and !is_attacking:
		animation_player.play(animation_idle)
	
	#Handles gravity and checks when to disable jump attacks
	if !is_on_floor():
		velocity.y += gravity * delta
	elif is_jump_high:
		is_attacking = false
		is_jump_high = false
	
	#Changes the player's speed and is_crouching bool based on their state
	if is_jump_high:
		is_crouching = false
		speed = flying_speed
	elif Input.is_action_pressed(down) and is_on_floor() and !is_attacking:
		is_crouching = true
		speed = crouching_speed
		animation_idle = "crouch_idle"
	else:
		is_crouching = false
		speed = standing_speed
		animation_idle = "stand_idle"
	
	#Checks if player wants to jump and can jump, then jumps
	if Input.is_action_just_pressed(up) and is_on_floor() and !is_crouching and !is_attacking:
		velocity.y = jump_velocity
	
	#Handles horizontal movement
	#Add acceleration over time when moving towards enemy to give aggressor the advantage
	var direction = Input.get_axis(left, right)
	if direction and !is_attacking or direction and is_jump_high: 
		velocity.x = direction * speed
		is_walking = true
	else:
		velocity.x = 0 #move_toward(velocity.x, 0, speed)
		is_walking = false
	
	#Moves and slides
	move_and_slide()

func _hit(damage, time):
	if player == 1:
		global.player_1_health -= damage
	elif player == 2:
		global.player_1_health -= damage
