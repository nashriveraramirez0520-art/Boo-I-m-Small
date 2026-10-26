
extends Area2D

signal scared

@export var scare_message: String = "BOO!"
@export var cooldown: float = 3.0

@onready var message_label: Label = get_node("../CanvasLayer/MessageLabel")

var boo_nearby: bool = false
var can_scare: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if boo_nearby and can_scare:
		if Input.is_action_just_pressed("Interact"):
			scare()

func scare() -> void:
	can_scare = false

	message_label.text = scare_message
	print(scare_message)
	scared.emit()

	await get_tree().create_timer(cooldown).timeout

	can_scare = true

	if boo_nearby:
		message_label.text = "Press E to scare!"
	elif message_label.text == scare_message:
		message_label.text = ""

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Boo":
		boo_nearby = true
		if can_scare:
			message_label.text = "Press E to scare!"

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Boo":
		boo_nearby = false
		if message_label.text == "Press E to scare!":
			message_label.text = ""
