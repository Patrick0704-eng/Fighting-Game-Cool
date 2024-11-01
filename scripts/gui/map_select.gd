extends Control
@onready var cursor_1 = $cursor_1
@onready var cursor_2 = $cursor_2
@onready var dual_select = $dual_cursor
#map selection number
var map_select_1 = 1
var map_select_2 = 1
#sees if selected map has been locked
var locked_1 = false
var locked_2 = false
#randomises whether player 1 or 2 will have priority
var pick_player_map = randi_range(1,2)
#random map button
var random_map = randi_range(1,2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if map_select_1 == 1:
		cursor_1.position = Vector2(100,32)	
	if map_select_2 == 1:
		cursor_2.position = Vector2(100,32)
	if map_select_1 == 2:
		cursor_1.position = Vector2(164,32)
	if map_select_2 == 2:
		cursor_2.position = Vector2(164,32)
	if map_select_1 == 3:
		cursor_1.position = Vector2(228,32)
	if map_select_2 == 3:
		cursor_2.position = Vector2(228,32)
	if map_select_1 == 1 and map_select_2 == 1:
		cursor_1.hide()
		cursor_2.hide()
		dual_select.position = Vector2(100,32)
		dual_select.show()
	elif map_select_1 == 2 and map_select_2 == 2:
		cursor_1.hide()
		cursor_2.hide()
		dual_select.position = Vector2(164,32)
		dual_select.show()
	elif map_select_1 == 3 and map_select_2 == 3:
		cursor_1.hide()
		cursor_2.hide()
		dual_select.position = Vector2(228,32)
		dual_select.show()
	else:
		dual_select.hide()
		cursor_1.show()
		cursor_2.show()
	if Input.is_action_just_pressed("lock_1"):
		locked_1 = true
	if Input.is_action_just_pressed("lock_2"):
		locked_2 = true
	if locked_1 and locked_2:
		if map_select_1 == 1 and map_select_2 == 1:
			global.map = 1
		if map_select_1 == 1 and map_select_2 == 2:
			if pick_player_map == 1:
				global.map = 1
			if pick_player_map == 2:
				global.map = 2
		if map_select_1 == 2 and map_select_2 == 1:
			if pick_player_map == 1:
				global.map = 2
			if pick_player_map == 2:
				global.map = 1
		if map_select_1 and map_select_2 == 2:
			global.map = 2
		if map_select_1 == 3 and map_select_2 == 1:
			if pick_player_map == 1:
				if random_map == 1:
					global.map = 1
				if random_map == 2:
					global.map = 2
			if pick_player_map == 2:
				global.map = 1
		if map_select_1 == 3 and map_select_2 == 2:
			if pick_player_map == 1:
				if random_map == 1:
					global.map =1
				if random_map == 2:
					global.map = 2
			if pick_player_map == 2:
				global.map = 2
		if map_select_1 == 3 and map_select_2 == 3:
			if random_map == 1:
				global.map = 1
			if random_map == 2:
				global.map = 2
		if map_select_1 == 2 and map_select_2 == 3:
			if pick_player_map == 1:
				global.map = 2
			if pick_player_map == 2:
				if random_map == 1:
					global.map = 1
				if random_map == 2:
					global.map = 2
		if map_select_1 == 1 and map_select_2 == 3:
			if pick_player_map == 1:
				global.map = 1
			if pick_player_map == 2:
				if random_map == 1:
					global.map = 1
				if random_map == 2:
					global.map= 2
		if global.map == 1:
			get_tree().change_scene_to_file("res://scenes/maps/temple.tscn")
		if global.map == 2:
			pass
	if !locked_1:
		if Input.is_action_just_pressed("right1"):
			if map_select_1 < 3:
				map_select_1 += 1
		if Input.is_action_just_pressed("left1"):
			if map_select_1 > 1:
				map_select_1 -= 1
	if !locked_2:
		if Input.is_action_just_pressed("right2"):
			if map_select_2 < 3:
				map_select_2 += 1
		if Input.is_action_just_pressed("left2"):
			if map_select_2 > 1:
				map_select_2 -=1
