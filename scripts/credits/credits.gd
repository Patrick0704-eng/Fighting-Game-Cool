extends Control
@onready var credits = $credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	credits.play()
	await get_tree().create_timer(5).timeout
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("high2"):
		get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
