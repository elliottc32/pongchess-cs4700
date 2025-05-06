class_name Piece
extends Area2D

@export var piece_sprite: Sprite2D
#var sprite_frame_dict: Dictionary = {
	#"Vertical Wall": 0,
	#"Horizontal Wall": 1,
	#"Empty": 2
#}
enum PieceType {VERTICAL_WALL, HORIZONTAL_WALL, VERTICAL_BORDER}
var piece_type: PieceType
var bounce_type: String

func _ready() -> void:
	match piece_type:
		PieceType.VERTICAL_WALL:
			piece_sprite.frame = 0
			bounce_type = "Vertical"
		PieceType.HORIZONTAL_WALL:
			piece_sprite.frame = 1
			bounce_type = "Horizontal"
		PieceType.VERTICAL_BORDER:
			piece_sprite.frame = 2 #Invisible
			bounce_type = "Vertical"

func initialize_piece(new_piece_type: PieceType) -> void:
	piece_type = new_piece_type
