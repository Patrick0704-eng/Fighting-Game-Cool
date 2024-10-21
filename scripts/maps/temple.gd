extends Node2D

#Define the variables to be used as character instances
var player1
var player2

#Preload hon to be instantiated
@onready var scene_hon = preload("res://scenes/characters/hon.tscn")

#Define the parent node of the players
@onready var players = $players

#Reference the camera variable
@onready var camera = $camera

func _ready():
	#Set both players' health to 100
	global.player1_health = 100
	global.player2_health = 100
	#Check player1's selected character and instantiate them
	if global.player1_character == 0:
		player1 = scene_hon.instantiate()
		player1.position = Vector2(-50, 0)
		player1.player = 1
		players.add_child(player1)
	#Check player2's selected character and instantiate them
	if global.player2_character == 0:
		player2 = scene_hon.instantiate()
		player2.position = Vector2(50, 0)
		player2.player = 2
		players.add_child(player2)


func _process(delta):
	#Set the camera's x position to the average x position of player 1 and player 2
	camera.position.x = player1.position.x /2 + player2.position.x /2
	
	#Make the camera zoom out more the further apart the players are
	var cza = 10.0 - abs(player1.position.x - player2.position.x) / 75.5
	#Prevent the camera zoom amount from being more than 5 or less than 3
	if cza > 5:
		cza = 5
	if cza < 3:
		cza = 3
	
	#Prevent the camera from moving to far to the right or left
	if camera.position.x >= 212:
		camera.position.x = 212
	elif camera.position.x <= 128:
		camera.position.x = 128
	camera.zoom = Vector2(cza, cza)
