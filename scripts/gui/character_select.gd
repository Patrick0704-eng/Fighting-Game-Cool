extends Control
@onready var cursor_1 = $player_1_cursor
@onready var cursor_2 = $player_2_cursor
@onready var grid_1 = $player_1
@onready var grid_2 = $player_2
@onready var hon = $player_1/hon
@onready var zhin = $player_1/zhin
@onready var hon_2 = $player_2/hon_2
@onready var zhin_2 = $player_2/zhin_2
@onready var dual_select = $dual_select
var locked_1
var locked_2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#change from texture buttons

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.player_1_character == 1:
		cursor_1.position = Vector2(100,32)	
	if global.player_2_character == 1:
		cursor_2.position = Vector2(100,32)
	if global.player_1_character == 2:
		cursor_1.position = Vector2(164,32)
	if global.player_2_character == 2:
		cursor_2.position = Vector2(164,32)
	if global.player_1_character == 1 and global.player_2_character == 1:
		cursor_1.hide()
		cursor_2.hide()
		dual_select.position = Vector2(100,32)
		dual_select.show()
	elif global.player_1_character == 2 and global.player_2_character == 2:
		cursor_1.hide()
		cursor_2.hide()
		dual_select.position = Vector2(164,32)
		dual_select.show()
	else:
		dual_select.hide()
		cursor_1.show()
		cursor_2.show()
	if Input.is_action_just_pressed("lock_1"):
		locked_1 = true
	if Input.is_action_just_pressed("lock_2"):
		locked_2 = true
	if !locked_1:
		if Input.is_action_just_pressed("right1"):
			if global.player_1_character < 2:
				global.player_1_character += 1
				#cursor_1.position.x += 
		if Input.is_action_just_pressed("left1"):
			if global.player_1_character > 1:
				global.player_1_character -= 1
				#cursor_1.position.x -=
	if !locked_2:
		if Input.is_action_just_pressed("right2"):
			if global.player_2_character < 2:
				global.player_2_character += 1
				#cursor_2.position.x +=
		if Input.is_action_just_pressed("left2"):
			if global.player_2_character > 1:
				global.player_2_character -=1
				#cursor_2.position.x -=
	if locked_1 and locked_2:
		get_tree().change_scene_to_file("res://scenes/maps/temple.tscn")


