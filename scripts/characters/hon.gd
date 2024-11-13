extends CharacterBody2D

#Define the hon's different speeds
var jump_high_speed = 150.0
var jump_low_speed = 100.0
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
var is_jump_high = false
var is_jump_low = false
var is_hit = false
var air_hit = false
#is_blocking 1 = false, 0.5 = true
var is_blocking = 1

#Define a variable to see whether or not the player is flipped (1 = false, -1 = true)
var is_flipped = 1

#Set the blocking animation to standing by default
var animation_block = "stand_block"

#Set the idle animation to standing by default
var animation_idle = "stand_idle"

#Define the variable to store the body that enters attack_range
var attack_range_body = null

#Reference hon's hitbox
@onready var hit_box = $hit_box

#Reference the animations
@onready var animation_frames = $animation_frames
@onready var animation_player = $animation_player

#Reference the attack range area
@onready var attack_range = $attack_range

#Reference the hon character body
@onready var hon_body = $"."

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
	#Change things if they are player2
	if player == 2:
		hon_body.collision_layer = 2
		hon_body.collision_mask = 2
		attack_range.collision_layer = 1
		attack_range.collision_mask = 1

func _physics_process(delta):
	#Flip the player if is flipped is true
	if is_flipped == -1:
		animation_frames.flip_h = true
		attack_range.position.x = -32
	else:
		animation_frames.flip_h = false
		attack_range.position.x = 40
	#Play the sun animation if the player is hit
	if is_hit:
		animation_player.play("stun")
	#Check if the player can block, then plays the animation and sets the is_blocking variable to true
	elif Input.is_action_pressed(block) and !is_attacking:
		is_attacking = true
		is_blocking = 0.5
		animation_player.play(animation_block)
	#Unblock if the player releases the block key
	elif Input.is_action_just_released(block) and is_blocking == 0.5:
		is_attacking = false
		is_blocking = 1
	#Check if the player can fly kick, then plays the animation and sets fly kick variables to true
	elif Input.is_action_just_pressed(high) and !is_on_floor() and !is_attacking:
		is_attacking = true
		is_jump_high = true
		animation_player.play("jump_high")
	#Check if the player can body slam, then plays the animation and sets body slam variables to true
	elif Input.is_action_just_pressed(low) and !is_on_floor() and !is_attacking:
		is_attacking = true
		is_jump_low = true
		animation_player.play("jump_low")
	#Check if player is trying and can standing high attack, then attacks
	elif !is_crouching and Input.is_action_just_pressed(high) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("stand_high")
		await get_tree().create_timer(0.2).timeout
		if !is_hit:
			if attack_range_body != null:
				attack_range_body._hit(5, 0.5, Vector2(20*is_flipped, -250))
			await get_tree().create_timer(0.3).timeout
		is_attacking = false
	#Check if player is trying and can standing low attack, then attacks
	elif !is_crouching and Input.is_action_just_pressed(low) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("stand_low")
		await get_tree().create_timer(0.2).timeout
		if attack_range_body != null:
			attack_range_body._hit(6, 0.7, Vector2(30*is_flipped, -350))
		await get_tree().create_timer(0.4).timeout
		is_attacking = false
	#Check if player is trying to crouching high and if they can, then executes the move
	elif is_crouching and Input.is_action_just_pressed(high) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("crouch_high")
		await get_tree().create_timer(0.2).timeout
		if !is_hit:
			if attack_range_body != null:
				attack_range_body._hit(4, 0.7, Vector2(25*is_flipped, -300))
			await get_tree().create_timer(0.3).timeout
		is_attacking = false
	#Check if player is trying to low blow and if they can, then executes the move
	elif is_crouching and Input.is_action_just_pressed(low) and is_on_floor() and !is_attacking:
		is_attacking = true
		animation_player.play("crouch_low")
		await get_tree().create_timer(0.4).timeout
		if !is_hit:
			if attack_range_body != null:
				attack_range_body._hit(15, 1.4, Vector2(0*is_flipped, 0))
			await get_tree().create_timer(0.5).timeout
		is_attacking = false
	#Checks if the standing walk animation should be played, then plays it based on velocity direction and is_flipped bool
	elif is_walking and !is_crouching and is_on_floor() and !is_attacking:
		if is_flipped == 1:
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
	#Checks if the player is jumping and playing no animations, then plays jump animation
	elif !is_on_floor() and !is_attacking:
		animation_player.play("jump")
	
	#Handles gravity and checks when to disable jump attacks
	if !is_on_floor():
		velocity.y += gravity * delta
	elif is_jump_high:
		is_attacking = false
		is_jump_high = false
		air_hit = false
	elif is_jump_low:
		is_attacking = false
		is_jump_low = false
		air_hit = false
	
	#Changes the player's speed and is_crouching bool based on their state. manages attacks in the air
	if is_jump_high:
		if attack_range_body != null and !air_hit and !is_hit:
			attack_range_body._hit(5, 0.5, Vector2(150*is_flipped, -200))
			air_hit = true
		is_crouching = false
		speed = jump_high_speed
	elif is_jump_low:
		if attack_range_body != null and !air_hit and !is_hit:
			attack_range_body._hit(3, 0.5, Vector2(75*is_flipped, -300))
			air_hit = true
		is_crouching = false
		speed = jump_low_speed
	elif Input.is_action_pressed(down) and is_on_floor() and !is_attacking:
		is_crouching = true
		speed = crouching_speed
		animation_idle = "crouch_idle"
		animation_block = "crouch_block"
	elif is_on_floor() and !is_attacking:
		is_crouching = false
		speed = standing_speed
		animation_idle = "stand_idle"
		animation_block = "stand_block"
	elif !is_on_floor() and !is_attacking:
		is_crouching = false
		speed = standing_speed
		animation_idle = "stand_idle"
		animation_block = "jump_block"
	
	#Checks if player wants to jump and can jump, then jumps
	if Input.is_action_just_pressed(up) and is_on_floor() and !is_crouching and !is_attacking:
		velocity.y = jump_velocity
	
	#Handles horizontal movement
	#Go faster when moving towards enemy to give aggressor the advantage
	var direction = Input.get_axis(left, right)
	if direction and !is_attacking and !is_hit or direction and is_jump_high or direction and is_jump_low: 
		velocity.x = direction * speed + is_flipped * 5
		is_walking = true
	elif !is_hit:
		velocity.x = 0 #move_toward(velocity.x, 0, speed)
		is_walking = false
	
	#Makes the player come out of stun if they touch the ground
	if is_hit and velocity.y >= 0 and is_on_floor():
		is_hit = false
		is_attacking = false
	
	#Moves and slides
	move_and_slide()

#Make the player stunned, take a certain amount of damage and knocback based on what numbers the attack sends
func _hit(damage, time, knockback):
	if player == 1:
		global.player_1_health -= damage * is_blocking
		if global.player_2_ult >= 100:
			global.player_2_ult = 100
		elif global.player_2_ult + damage * 3 >= 100:
			global.player_2_ult = 100
		else:
			global.player_2_ult += damage * 3
	elif player == 2:
		global.player_2_health -= damage * is_blocking
		if global.player_1_ult >= 100:
			global.player_1_ult = 100
		elif global.player_1_ult + damage * 3 >= 100:
			global.player_1_ult = 100
		else:
			global.player_1_ult += damage * 3
	#velocity = knockback * is_blocking
	if is_blocking == 1:
		velocity = knockback
		if knockback.y < 0:
			is_hit = true
	is_jump_high = false
	is_jump_low = false
	is_attacking = true

#Save the body that enters the area as a variable if it is in the group "player"
func _on_attack_range_body_entered(body):
	if body.is_in_group("player"):
		attack_range_body = body

#Clear the variable saving the body that entered when the body leaves if it is in the group "player"
func _on_attack_range_body_exited(body):
	if body.is_in_group("player"):
		attack_range_body = null
