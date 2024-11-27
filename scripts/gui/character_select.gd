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
@onready var player_1_lock = $locked_1
@onready var player_2_lock = $locked_2
@onready var dual_locked = $dual_locked
@onready var locked_1_unlocked_2 = $locked_1_unlocked_2
@onready var locked_2_unlocked_1 = $locked_2_unlocked_1
@onready var scroll_1 = $scroll_1
@onready var scroll_2 = $scroll_2
@onready var lockies_1 = $lockies_1
@onready var lockies_2 = $lockies_2
@onready var choose = $choose_character
var locked_1
var locked_2
# Called when the node enters the scene tree for the first time.
func _ready():
	choose.play()
#change from texture buttons

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.player_1_character == 1:
		player_1_lock.position = Vector2(100,32)
	if global.player_1_character == 2:
		player_1_lock.position = Vector2(164,32)
	if global.player_2_character == 1:
		player_2_lock.position = Vector2(100,32)
	if global.player_2_character == 2:
		player_2_lock.position = Vector2(164,32)
	if !locked_1 and !locked_2:
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
			player_1_lock.hide()
			player_2_lock.hide()
			locked_1_unlocked_2.hide()
			locked_2_unlocked_1.hide()
			dual_locked.hide()
	if locked_1 and !locked_2:
		cursor_1.hide()
		if global.player_1_character == 1 and global.player_2_character == 2:
			cursor_2.show()
			cursor_2.position = Vector2(164,32)
			locked_1_unlocked_2.hide()
			player_1_lock.position = Vector2(100,32)
			player_1_lock.show()
		if global.player_1_character == 1 and global.player_2_character == 1:
			player_1_lock.hide()
			cursor_2.hide()
			locked_1_unlocked_2.position = Vector2(100,32)
			locked_1_unlocked_2.show()
		if global.player_1_character == 2 and global.player_2_character == 1:
			cursor_2.show()
			cursor_2.position = Vector2(100,32)
			locked_1_unlocked_2.hide()
			player_1_lock.position = Vector2(164,32)
			player_1_lock.show()
		if global.player_1_character == 2 and global.player_2_character == 2:
			cursor_2.hide()
			player_1_lock.hide()
			locked_1_unlocked_2.position = Vector2(164,32)
			locked_1_unlocked_2.show()
	if locked_2 and !locked_1:
		cursor_2.hide()
		if global.player_2_character == 1 and global.player_1_character == 2:
			cursor_1.show()
			cursor_1.position = Vector2(164,32)
			locked_2_unlocked_1.hide()
			player_2_lock.position = Vector2(100,32)
			player_2_lock.show()
		if global.player_2_character == 1 and global.player_1_character == 1:
			player_2_lock.hide()
			cursor_1.hide()
			locked_2_unlocked_1.position = Vector2(100,32)
			locked_2_unlocked_1.show()
		if global.player_2_character == 2 and global.player_1_character == 1:
			cursor_1.show()
			cursor_1.position = Vector2(100,32)
			locked_2_unlocked_1.hide()
			player_2_lock.position = Vector2(164,32)
			player_2_lock.show()
		if global.player_2_character == 2 and global.player_1_character == 2:
			cursor_1.hide()
			player_2_lock.hide()
			locked_2_unlocked_1.position = Vector2(164,32)
			locked_2_unlocked_1.show()
	if locked_1 and locked_2:
		if global.player_1_character == global.player_2_character:
			player_1_lock.hide()
			player_2_lock.hide()
			locked_1_unlocked_2.hide()
			locked_2_unlocked_1.hide()
			cursor_1.hide()
			cursor_2.hide()
			if global.player_1_character == 1:
				dual_locked.position = Vector2(100,32)
				dual_locked.show()
			if global.player_1_character == 2:
				dual_locked.position = Vector2(164,32)
				dual_locked.show()
		if global.player_1_character == 1 and global.player_2_character ==2:
			player_1_lock.position = Vector2(100,32)
			player_2_lock.position = Vector2(164,32)
			player_1_lock.show()
			player_2_lock.show()
		if global.player_1_character == 2 and global.player_2_character == 1:
			player_1_lock.position = Vector2(164,32)
			player_2_lock.position = Vector2(100,32)
			player_1_lock.show()
			player_2_lock.show()
	if Input.is_action_just_pressed("lock_1"):
		locked_1 = true
		lockies_1.play()
	if Input.is_action_just_pressed("lock_2"):
		locked_2 = true
		lockies_1.play()
	if !locked_1:
		if Input.is_action_just_pressed("right1"):
			if global.player_1_character < 2:
				global.player_1_character += 1
				scroll_1.play()
		if Input.is_action_just_pressed("left1"):
			if global.player_1_character > 1:
				global.player_1_character -= 1
				scroll_1.play()
	if !locked_2:
		if Input.is_action_just_pressed("right2"):
			if global.player_2_character < 2:
				global.player_2_character += 1
				scroll_2.play()
		if Input.is_action_just_pressed("left2"):
			if global.player_2_character > 1:
				global.player_2_character -=1
				scroll_2.play()
	if locked_1 and locked_2:
		if global.player_1_character == global.player_2_character:
			player_1_lock.hide()
			player_2_lock.hide()
			locked_1_unlocked_2.hide()
			locked_2_unlocked_1.hide()
			cursor_1.hide()
			cursor_2.hide()
			if global.player_1_character == 1:
				dual_locked.position = Vector2(100,32)
				dual_locked.show()
			if global.player_1_character == 2:
				dual_locked.position = Vector2(164,32)
				dual_locked.show()
		if global.player_1_character == 1 and global.player_2_character == 2:
			player_1_lock.position = Vector2(100,32)
			player_2_lock.position = Vector2(164,32)
			player_1_lock.show()
			player_2_lock.show()
		if global.player_1_character == 2 and global.player_2_character == 1:
			player_1_lock.position = Vector2(164,32)
			player_2_lock.position = Vector2(100,32)
			player_1_lock.show()
			player_2_lock.show()
		await get_tree().create_timer(2.5).timeout
		get_tree().change_scene_to_file("res://scenes/gui/map_select.tscn")
