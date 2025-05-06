extends GridContainer

@export var grid_space_button_scene: PackedScene

func _ready() -> void:
	for i in range(1,13):
		for j in range(1,13):
			var grid_space_button_instance = grid_space_button_scene.instantiate()
			grid_space_button_instance.grid_position = Vector2(-104, -104) + ((Vector2(i, j) * 16))
			grid_space_button_instance.visible = false
			add_child(grid_space_button_instance)

func show_available_spaces_for_wall_piece(player: String) -> void:
	pass

func show_available_spaces_for_bomb(pieces_array: Array) -> void:
	pass

func hide_all_buttons() -> void:
	pass
