extends Node2D

#Define the variables to be used as character instances
var player1
var player2

#Define the bool to determine whether the game is over
var game_over = false

#Stops from double spawning characters in start func
var birth = true

var player_2_victory = false

var player_1_victory = false
#countdown timer
var fight_counter = 3

var game_started = false
#defines audio
@onready var fight_countdown = $"321_fight"
@onready var player_1_win = $player_1_win
@onready var player_2_win = $player_2_win
@onready var ko = $ko
@onready var hon_start = $hon_start
@onready var hon_win = $hon_win
@onready var hon_loss = $hon_loss
@onready var zhin_win = $zhin_win
@onready var zhin_loss = $zhin_loss
@onready var zhin_start = $zhin_start

#Preload hon to be instantiated
@onready var scene_hon = preload("res://scenes/characters/hon.tscn")
@onready var scene_zhin = preload("res://scenes/characters/zhin.tscn")

#Reference the temple scene
@onready var scene_temple = "res://scenes/maps/temple.tscn"

#Define the parent node of the players
@onready var players = $players

@onready var countdown = $Label

#Reference the camera variable
@onready var camera = $camera

#Reference the health bars
@export var player_1_health: TextureProgressBar
@onready var player_2_health = $CanvasLayer/resizer/player_2_health

#Reference the ultimate bars
@onready var player_1_ult = $CanvasLayer/resizer/player_1_ult
@onready var player_2_ult = $CanvasLayer/resizer/player_2_ult

#Reference the ultimate percentage label
@onready var player_1_ult_percentage = $CanvasLayer/resizer/player_1_ult_percentage
@onready var player_2_ult_percentage = $CanvasLayer/resizer/player_2_ult_percentage

#Reference the timer and the timer display
@onready var time_display = $CanvasLayer/resizer/time_display
@onready var timer = $CanvasLayer/resizer/timer

#Reference the pause menu scene
@onready var pause_menu = $CanvasLayer/resizer/pause_menu

#Reference song
@onready var theme = $"fight theme"

@onready var player_1_dub = $player_1_dub
@onready var player_2_dub = $player_2_dub
func _ready():
	time_display.text = "Ready?"
	global.player_1_wins = 0
	global.player_2_wins = 0
	AudioPlayer.stop()
	theme.play()
	
	
	#Set both players' health to 100
	global.player_1_health = 100
	global.player_2_health = 100
	#Check player1's selected character and instantiate them
	if global.player_1_character == 1:
		player1 = scene_hon.instantiate()
		player1.position = Vector2(-50, 0)
		player1.player = 1
		player1.is_attacking = true
		players.add_child(player1)
	if global.player_1_character == 2:
		player1 = scene_zhin.instantiate()
		player1.position = Vector2(-50, 0)
		player1.player = 1
		player1.is_attacking = true
		players.add_child(player1)
	#Check player2's selected character and instantiate them
	if global.player_2_character == 1:
		player2 = scene_hon.instantiate()
		player2.position = Vector2(50, 0)
		player2.player = 2
		player2.is_attacking = true
		players.add_child(player2)
	if global.player_2_character == 2:
		player2 = scene_zhin.instantiate()
		player2.position = Vector2(50, 0)
		player2.player = 2
		player2.is_attacking = true
		players.add_child(player2)
	_pre_trash_talk()


func _process(delta):
	countdown.text = str(fight_counter)
	#Open the pause menu and pause the game if esc is pressed
	if Input.is_action_just_pressed("esc"):
		pause_menu.show()
		get_tree().paused = true
	
	#Set the health bars to reflect each player's health
	player_1_health.value = global.player_1_health
	player_2_health.value = global.player_2_health
	
	#Set the ultimate bars to reflect each player's ult percentage
	player_1_ult.value = global.player_1_ult
	player_2_ult.value = global.player_2_ult
	
	#Set the ultimate percentage label to reflect each player's ult percentage
	if global.player_1_ult != 100:
		player_1_ult_percentage.text = str(global.player_1_ult, "%")
	else:
		player_1_ult_percentage.text = "ULT"
	if global.player_2_ult != 100:
		player_2_ult_percentage.text = str(global.player_2_ult, "%")
	else:
		player_2_ult_percentage.text = "ULT"
	
	if game_started:
		#Set the camera's x position to the average x position of player 1 and player 2
		camera.position.x = player1.position.x + player2.position.x + 328
		
		#Make the camera zoom out more the further apart the players are
		var cza = 9.0 - abs(player1.position.x - player2.position.x) / 75.5
		#Prevent the camera zoom amount from being more than 5 or less than 3
		if cza > 5:
			cza = 5
		if cza < 3:
			cza = 3
		
		#Prevent the camera from moving to far to the right or left
		if camera.position.x >= 452:
			camera.position.x = 452
		elif camera.position.x <= 196:
			camera.position.x = 196
		camera.zoom = Vector2(cza, cza)
	
	#Flip the players if the pass by each other
	if player1.position.x > player2.position.x:
		player1.is_flipped = -1
		player2.is_flipped = 1
	else:
		player1.is_flipped = 1
		player2.is_flipped = -1
	
	#Manage the wins/losses
	#Add a K.O. player animation and text and stuff. Also reset the round and more
	if game_started:
		if global.player_1_health <= 0:
			game_over = true
			time_display.text = "K.O."
			ko.play()
			global.player_2_wins += 1
		elif global.player_2_health <= 0:
			game_over = true
			time_display.text = "K.O."
			ko.play()
			global.player_1_wins += 1
		elif timer.time_left <= 0:
			game_over = true
			time_display.text = " --"
			if global.player_1_health > global.player_2_health:
				global.player_1_wins += 1
			elif global.player_2_health > global.player_1_health:
				global.player_2_wins += 1
			else:
				pass #no one wins
	
	if game_over:
		player1.is_attacking = true
		player2.is_attacking = true
		if global.player_1_wins < 2 and global.player_2_wins < 2:
			birth = false
			_start()
			game_over = false
	
	if global.player_1_wins == 2:
		player_1_dub.show()
		player_1_win.play()
		await get_tree().create_timer(2).timeout
		if global.player_1_character == 1:
			hon_win.play()
		if global.player_1_character == 2:
			zhin_win.play()
		await get_tree().create_timer(7).timeout
		if global.player_2_character == 1:
			hon_loss.play()
		if global.player_2_character ==2:
			zhin_loss.play()
		await get_tree().create_timer(7).timeout
		get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
	if global.player_2_wins == 2:
		player_2_dub.show()
		player_2_win.play()
		await get_tree().create_timer(2).timeout
		if global.player_2_character == 1:
			hon_win.play()
		if global.player_2_character == 2:
			zhin_win.play()
		await get_tree().create_timer(7).timeout
		if global.player_1_character == 1:
			hon_loss.play()
		if global.player_1_character == 2:
			zhin_loss.play()
		await get_tree().create_timer(7).timeout
		get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
		
	#Display the timer
	if !game_over and game_started:
		var time_left = timer.time_left
		var minutes = floor(time_left / 60)
		var seconds = int(time_left) % 60
		if seconds > 9:
			time_display.text = str(minutes,":", seconds)
		else:
			time_display.text = str(minutes,":0", seconds)
	else:
		timer.stop()

func _pre_trash_talk():
	camera.position = Vector2(274,200)
	camera.zoom = Vector2(8.5,8.5)
	if global.player_1_character == 1:
		hon_start.play()
	if global.player_1_character == 2:
		zhin_start.play()
	await get_tree().create_timer(7).timeout
	camera.position = Vector2(324,200)
	if global.player_2_character == 1 and global.player_1_character > 1:
		hon_start.play()
	if global.player_2_character == 1 and global.player_1_character == 1:
		pass
	if global.player_2_character == 2 and global.player_1_character ==1:
		zhin_start.play()
	if global.player_2_character == 2 and global.player_1_character ==2:
		pass
	await get_tree().create_timer(7).timeout
	_start()
func _start():
	time_display.text = str(fight_counter)
	if !birth:
		player1.is_attacking = true
		player1.position = Vector2 (-50,0)
		player2.is_attacking = true
		player2.position = Vector2 (50,0)
		global.player_1_health = 100
		global.player_2_health = 100
	fight_countdown.play()
	await get_tree().create_timer(0.8).timeout
	fight_counter -=1
	time_display.text = str(fight_counter)
	await get_tree().create_timer(0.8).timeout
	fight_counter -=1
	time_display.text = str(fight_counter)
	await get_tree().create_timer(0.8).timeout
	fight_counter -=1
	time_display.text = str(fight_counter)
	if fight_counter == 0:
		time_display.text = str(fight_counter)
		player1.is_attacking = false
		player2.is_attacking = false
		fight_counter = "go"
		countdown.hide()
		#Start the timer
		time_display.text = "Fight"
		await get_tree().create_timer(1).timeout
		timer.start()
		game_started = true
		fight_counter = 3
