extends Node2D

@export var grid_space_scene: PackedScene
var array_of_grid_spaces: Array = [] #This is a 2D Array
enum CurrentSelection {VERTICAL_WALL, HORIZONTAL_WALL, BOMB}
var current_selection: CurrentSelection
var bomb_button_count: int
signal finished_placing_pieces()

func _ready() -> void:
	for i in range(0,14):
		var column = []
		for j in range(0,14):
			var grid_space_instance = grid_space_scene.instantiate()
			add_child(grid_space_instance)
			grid_space_instance.go_to_grid_position(Vector2i(i, j))
			column.append(grid_space_instance)
		array_of_grid_spaces.append(column)

func check_space(grid_position_to_check: Vector2i) -> String:
	if array_of_grid_spaces[grid_position_to_check.x][grid_position_to_check.y].piece == null:
		return "Nothing"
	else:
		match array_of_grid_spaces[grid_position_to_check.x][grid_position_to_check.y].piece.piece_type:
			Piece.PieceType.VERTICAL_WALL:
				return "Vertical"
			Piece.PieceType.HORIZONTAL_WALL:
				return "Horizontal"
			Piece.PieceType.VERTICAL_BORDER:
				return "Vertical"
			_:
				return "Nothing"

func clear_all_pieces() -> void:
	for column in array_of_grid_spaces:
		for i in column:
			i.piece = null

func place_border_pieces() -> void:
	for i in array_of_grid_spaces[0]:
		i.create_piece(Piece.PieceType.VERTICAL_BORDER)
	for i in array_of_grid_spaces[13]:
		i.create_piece(Piece.PieceType.VERTICAL_BORDER)

func show_available_spaces_for_wall_piece(player: String) -> void:
	if player == "Player1":
		for column in array_of_grid_spaces:
			for i in range(0,7):
				if column[i].piece == null:
					column[i].show_button()
	else:
		for column in array_of_grid_spaces:
			for i in range(7,14):
				if column[i].piece == null:
					column[i].show_button()

func show_available_spaces_for_bomb() -> void:
	for column in range(1,13):
		for i in array_of_grid_spaces[column]:
			if i.piece != null:
				i.show_button()

func hide_all_buttons() -> void:
	for column in array_of_grid_spaces:
		for i in column:
			i.hide_button()

func check_number_of_pieces() -> int:
	var sum_of_pieces: int = 0
	for column in range(1,13):
		for i in array_of_grid_spaces[column]:
			if i.piece != null:
				sum_of_pieces += 1
	return sum_of_pieces

func _on_grid_space_button_pushed(button_grid_position: Vector2i) -> void:
	if current_selection == CurrentSelection.VERTICAL_WALL:
		hide_all_buttons()
		array_of_grid_spaces[button_grid_position.x][button_grid_position.y].create_piece(Piece.PieceType.VERTICAL_WALL)
		finished_placing_pieces.emit()
	elif current_selection == CurrentSelection.HORIZONTAL_WALL:
		hide_all_buttons()
		array_of_grid_spaces[button_grid_position.x][button_grid_position.y].create_piece(Piece.PieceType.HORIZONTAL_WALL)
		finished_placing_pieces.emit()
	else:
		if bomb_button_count == 0:
			array_of_grid_spaces[button_grid_position.x][button_grid_position.y].hide_button()
			array_of_grid_spaces[button_grid_position.x][button_grid_position.y].piece = null
		else:
			hide_all_buttons()
			bomb_button_count = 0
			array_of_grid_spaces[button_grid_position.x][button_grid_position.y].piece = null
			finished_placing_pieces.emit()
