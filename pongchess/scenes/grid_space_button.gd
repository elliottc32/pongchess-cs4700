class_name GridSpaceButton
extends TextureButton

@export var debug_selection_sprite: CompressedTexture2D
var grid_position: Vector2i
signal pushed(pushed_grid_position: Vector2i)

func hide_button() -> void:
	texture_normal = null

func show_button() -> void:
	texture_normal = debug_selection_sprite

func _on_pressed() -> void:
	pushed.emit(grid_position)
