extends Area2D

#Define the variable to hold the player inside the hitbox
var attack_range_body = null

#variables
var fireball_direction = 1
var player = 1
var speed = 150

@onready var animation = $fireball_animation

func _ready():
	if fireball_direction < 0:
		animation.flip_h = true


func _process(delta):
	position.x -= speed * delta * (-fireball_direction)
	if global_position.x < 0:
		queue_free()
	if global_position.x > 1000:
		queue_free()
	if attack_range_body != null:
		if attack_range_body.is_in_group("player"):
			attack_range_body._hit(5, 0.5, Vector2(20*fireball_direction, -250))
			queue_free()

func _on_body_entered(body):
	attack_range_body = body


func _on_body_exited(body):
	attack_range_body = null


func _on_area_entered(area):
	if area.is_in_group("fireball"):
			queue_free()
