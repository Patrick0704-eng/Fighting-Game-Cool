extends Control
@onready var credits_player = $credits
var video_stream : VideoStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	video_stream = preload("res://assets/voicelines/Credits.ogv")
	credits_player.stream = video_stream
	credits_player.play()
	await get_tree().create_timer(20).timeout
	$Label.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("high2"):
		get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
