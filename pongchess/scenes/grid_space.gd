extends Node2D

var grid_position: Vector2i
var piece: Piece :
	set(value):
		if piece != null:
			remove_child(piece)
			add_child(value)
		piece = value
@export var piece_scene: PackedScene

func go_to_grid_position(new_position: Vector2i) -> void:
	position = Vector2(-104, -104) + ((Vector2(new_position) * 16))
	grid_position = new_position

func create_piece(piece_type: Piece.PieceType) -> void:
	var piece_instance = piece_scene.instantiate()
	piece_instance.initialize_piece(piece_type)
	add_child(piece_instance)
	piece = piece_instance
