extends Node2D
@export var top_player_pieces_manager: Node2D
@export var bottom_player_pieces_manager: Node2D
@export var border_pieces_manager: Node2D
@export var piece_scene: PackedScene
enum PieceLocation {TOP, BOTTOM, BORDER}

func place_piece(piece_type: Piece.PieceType, piece_location: PieceLocation, piece_position: Vector2i) -> void:
	#-104,-104 is the top left corner of the grid in the center of that grid position
	var piece_instance = piece_scene.instantiate()
	piece_instance.position = Vector2(-104, -104) + (Vector2(piece_position) * 16)
	piece_instance.initialize_piece(piece_type)
	match piece_location:
		PieceLocation.TOP:
			top_player_pieces_manager.add_child(piece_instance)
		PieceLocation.BOTTOM:
			bottom_player_pieces_manager.add_child(piece_instance)
		PieceLocation.BORDER:
			border_pieces_manager.add_child(piece_instance)
		_:
			assert(false, "Piece tried to be placed in an illegal PieceLocation")

func place_border_pieces() -> void:
	for i in range(0,14):
		place_piece(Piece.PieceType.VERTICAL_BORDER, PieceLocation.BORDER, Vector2i(0, i))
		place_piece(Piece.PieceType.VERTICAL_BORDER, PieceLocation.BORDER, Vector2i(13, i))

func clear_bottom_pieces() -> void:
	for i in bottom_player_pieces_manager.get_children():
		i.clear_piece()

func clear_top_pieces() -> void:
	for i in top_player_pieces_manager.get_children():
		i.clear_piece()

func clear_all_pieces() -> void:
	clear_bottom_pieces()
	clear_top_pieces()
	for i in border_pieces_manager.get_children():
		i.clear_piece()
