extends Node2D

#Define the variables to be used as character instances
var player1
var player2

#Preload hon to be instantiated
@onready var scene_hon = preload("res://scenes/characters/hon.tscn")
@onready var scene_zhin = preload("res://scenes/characters/zhin.tscn")

#Define the parent node of the players
@onready var players = $players

#Reference the camera variable
@onready var camera = $camera

#Reference the health bars
@onready var player_1_health = $CanvasLayer/player_1_health
@onready var player_2_health = $CanvasLayer/player_2_health

func _ready():
	#Set both players' health to 100
	global.player_1_health = 100
	global.player_2_health = 100
	#Check player1's selected character and instantiate them
	if global.player_1_character == 1:
		player1 = scene_hon.instantiate()
		player1.position = Vector2(-50, 0)
		player1.player = 1
		players.add_child(player1)
	if global.player_1_character == 2:
		player1 = scene_zhin.instantiate()
		player1.position = Vector2(-50, 0)
		player1.player = 1
		players.add_child(player1)
	#Check player2's selected character and instantiate them
	if global.player_2_character == 1:
		player2 = scene_hon.instantiate()
		player2.position = Vector2(50, 0)
		player2.player = 2
		players.add_child(player2)
	if global.player_2_character == 2:
		player2 = scene_zhin.instantiate()
		player2.position = Vector2(50, 0)
		player2.player = 2
		players.add_child(player2)


func _process(delta):
	#Set the health bars to reflect each player's health
	player_1_health.value = global.player_1_health
	player_2_health.value = global.player_2_health
	
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
	
