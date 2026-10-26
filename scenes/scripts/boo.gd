extends CharacterBody2D

@onready var sprite: Sprite2D = get_node("Sprite2D")
var float_time: float = 0.0

@export var speed: float = 150.0

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
		)
	
	velocity = direction * speed
	move_and_slide()
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false

	float_time += _delta
	sprite.position.y = sin(float_time * 3.0) * 3.0
