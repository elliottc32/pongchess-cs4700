class_name GridButton
extends PanelContainer

@export var selection_texture: CompressedTexture2D
@export var button: Button
var grid_position: Vector2i

func show_button() -> void:
	button.icon = selection_texture

func hide_button() -> void:
	button.icon = null
