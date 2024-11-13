extends Control

#Reference the main menu scene
@onready var main_menu = "res://scenes/gui/main_menu.tscn"

func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("esc"):
		hide()
		get_tree().paused =	 false
		#ADD A COUNT IN TIMER WHEN UNPAUSING


func _on_resume_pressed():
	hide()
	get_tree().paused =	 false
	#ADD A COUNT IN TIMER WHEN UNPAUSING


func _on_return_pressed():
	get_tree().change_scene_to_file(main_menu)
