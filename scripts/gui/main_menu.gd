extends Control


func _ready():
	pass


func _process(_delta):
	pass


func _on_play_pressed():
	#Will change this to character select scene
	get_tree().change_scene_to_file("res://scenes/gui/character_select.tscn")
