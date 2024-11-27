extends Control


func _ready():
	pass


func _process(_delta):
	#Switch to character select if space or enter pressed
	if Input.is_action_just_pressed("lock_1"):
		get_tree().change_scene_to_file("res://scenes/gui/character_select.tscn")
	if Input.is_action_just_pressed("lock_2"):
		get_tree().change_scene_to_file("res://scenes/gui/character_select.tscn")
	
	#Quit if the player presses escape
	if Input.is_action_just_pressed("esc"):
		#Add an "Are you sure you want to quit?"
		get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/gui/character_select.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")
