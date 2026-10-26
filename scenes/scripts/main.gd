
extends Node2D

var fear: int = 0
var max_fear: int = 100
var won: bool = false

@onready var fear_label: Label = $CanvasLayer/FearLabel
@onready var window_interaction = $"Window Interaction"
@onready var door_interaction = $"Door Interaction"
@onready var human_sprite: Sprite2D = $Human/Sprite2D

var win_label: Label
var reaction_tween: Tween

func _ready() -> void:
	window_interaction.scared.connect(_on_scared)
	door_interaction.scared.connect(_on_scared)

	win_label = Label.new()
	$CanvasLayer.add_child(win_label)
	win_label.text = "YOU WIN! BOO IS A REAL GHOST!"
	win_label.position = Vector2(120, 60)
	win_label.add_theme_font_size_override("font_size", 20)
	win_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
	win_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0))
	win_label.add_theme_constant_override("shadow_offset_x", 3)
	win_label.add_theme_constant_override("shadow_offset_y", 3)
	win_label.visible = false

	update_fear_label()

func _on_scared() -> void:
	if won:
		return

	fear = min(fear + 20, max_fear)
	update_fear_label()

	if reaction_tween and reaction_tween.is_running():
		reaction_tween.kill()

	human_sprite.rotation_degrees = 0

	if fear >= max_fear:
		won = true
		win_label.visible = true
		human_run_away()
	else:
		human_get_scared()

func human_get_scared() -> void:
	reaction_tween = create_tween()

	reaction_tween.tween_property(
		human_sprite, "rotation_degrees", -8.0, 0.08
	)
	reaction_tween.tween_property(
		human_sprite, "rotation_degrees", 8.0, 0.16
	)
	reaction_tween.tween_property(
		human_sprite, "rotation_degrees", -8.0, 0.16
	)
	reaction_tween.tween_property(
		human_sprite, "rotation_degrees", 0.0, 0.08
	)

func human_run_away() -> void:
	reaction_tween = create_tween()
	reaction_tween.tween_property(
		human_sprite,
		"position",
		human_sprite.position + Vector2(650, 0),
		1.0
	)

func update_fear_label() -> void:
	fear_label.text = "Fear: " + str(fear) + " / " + str(max_fear)
