extends Node
@export var grid_spaces_manager: Node2D
@export var grid_space_button_manager: GridContainer
@export var ball_holder: Node2D
@export var background_tile_map: TileMapLayer
@export var game_ui_canvaslayer: CanvasLayer
@export var placeable_pieces_buttons: VBoxContainer
@export var turn_label: Label
@export var p1_points_label: Label
@export var p2_points_label: Label
@export var bomb_button: TextureButton
@export var ball_scene: PackedScene
var ball: RigidBody2D
enum CurrentTurn {PLAYER1, PLAYER2, MOVEBALL}
var current_turn: CurrentTurn
var p1: String
var p2: String
var p1_score: int
var p2_score: int

#Ball variables
@export var ball_speed: float
@export var ball_move_speed_timer: Timer
enum BounceDirection {UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT}
var ball_bounce_direction: BounceDirection
var ball_grid_position: Vector2

func _ready() -> void:
	ball_move_speed_timer.wait_time = ball_speed
	placeable_pieces_buttons.visible = false

func turn_invisible() -> void:
	background_tile_map.visible = false
	grid_spaces_manager.visible = false
	ball_holder.visible = false
	game_ui_canvaslayer.visible = false

func turn_visible() -> void:
	background_tile_map.visible = true
	grid_spaces_manager.visible = true
	ball_holder.visible = true
	game_ui_canvaslayer.visible = true

func new_game(player1: String, player2: String) -> void:
	p1 = player1
	p2 = player2
	p1_score = 0
	p2_score = 0
	p1_points_label.text = "P1 Points: " + str(p1_score)
	p2_points_label.text = "P2 Points: " + str(p2_score)
	start_game()

func start_game() -> void:
	if ball_holder.get_child_count() > 0:
		for i in ball_holder.get_children():
			i.queue_free()
			
	grid_spaces_manager.clear_all_pieces()
	grid_spaces_manager.place_border_pieces()
	
	var ball_instance: RigidBody2D = ball_scene.instantiate()
	ball_holder.add_child(ball_instance)
	ball = ball_instance
	
	ball_grid_position = Vector2(6.5, 6.5)
	ball_bounce_direction = BounceDirection.UPRIGHT
	
	if randi() % 2 == 0:
		turn_change(CurrentTurn.PLAYER1)
	else:
		turn_change(CurrentTurn.PLAYER2)

func turn_change(new_turn: CurrentTurn) -> void:
	current_turn = new_turn
	if current_turn == CurrentTurn.MOVEBALL:
		move_ball()
		return
	if current_turn == CurrentTurn.PLAYER1:
		turn_label.text = "Player 1's Turn!"
	else:
		turn_label.text = "Player 2's Turn!"
	if (current_turn == CurrentTurn.PLAYER1 and p1 == "COM") or (current_turn == CurrentTurn.PLAYER2 and p2 == "COM"):
		do_ai_turn()
		return
	#If we reach this point, it means the player is human
	placeable_pieces_buttons.visible = true
	if grid_spaces_manager.check_number_of_pieces() == 0:
		bomb_button.visible = false
	else:
		bomb_button.visible = true
	#Now we wait for the player to hit one of the buttons
	
func do_ai_turn() -> void:
	pass

func move_ball() -> void:
	match ball_bounce_direction:
		BounceDirection.UPRIGHT:
			ball_grid_position += Vector2(0.5,-0.5)
		BounceDirection.UPLEFT:
			ball_grid_position += Vector2(-0.5,-0.5)
		BounceDirection.DOWNRIGHT:
			ball_grid_position += Vector2(0.5,0.5)
		BounceDirection.DOWNLEFT:
			ball_grid_position += Vector2(-0.5,0.5)
	
	if is_equal_approx(ball_grid_position.y, -1):
		ball.queue_free()
		p2_score += 1
		p2_points_label.text = "P2 Points: " + str(p2_score)
		return
	elif is_equal_approx(ball_grid_position.y, 14):
		ball.queue_free()
		p1_score += 1
		p1_points_label.text = "P1 Points: " + str(p1_score)
		return
	elif is_equal_approx(ball_grid_position.y, 6.5):
		if ball_bounce_direction == BounceDirection.UPRIGHT or ball_bounce_direction == BounceDirection.UPLEFT:
			current_turn = CurrentTurn.PLAYER1
		else:
			current_turn = CurrentTurn.PLAYER2
		return
	
	ball.position = Vector2(-104, -104) + ((Vector2(ball_grid_position) * 16))
	if is_equal_approx(fmod(ball_grid_position.x, 1), 0): #x and y should both be the same decimal point here
		var bounce:String = grid_spaces_manager.check_space(Vector2i(ball_grid_position))
		var prev_bounce_direction = ball_bounce_direction
		match bounce:
			"Horizontal":
				match prev_bounce_direction:
					BounceDirection.UPRIGHT:
						ball_bounce_direction = BounceDirection.DOWNRIGHT
					BounceDirection.UPLEFT:
						ball_bounce_direction = BounceDirection.DOWNLEFT
					BounceDirection.DOWNRIGHT:
						ball_bounce_direction = BounceDirection.UPRIGHT
					BounceDirection.DOWNLEFT:
						ball_bounce_direction = BounceDirection.UPLEFT
			"Vertical":
				match prev_bounce_direction:
					BounceDirection.UPRIGHT:
						ball_bounce_direction = BounceDirection.UPLEFT
					BounceDirection.UPLEFT:
						ball_bounce_direction = BounceDirection.UPRIGHT
					BounceDirection.DOWNRIGHT:
						ball_bounce_direction = BounceDirection.DOWNLEFT
					BounceDirection.DOWNLEFT:
						ball_bounce_direction = BounceDirection.DOWNRIGHT
	ball_move_speed_timer.start()

func _on_ball_move_speed_timer_timeout() -> void:
	move_ball()

func _on_vertical_wall_button_pressed() -> void:
	placeable_pieces_buttons.visible = false
	var player: String
	if current_turn == CurrentTurn.PLAYER1:
		player = "Player1"
	else:
		player = "Player2"
	grid_space_button_manager.show_available_spaces_for_wall_piece(player)

func _on_horizontal_wall_button_pressed() -> void:
	placeable_pieces_buttons.visible = false
	var player: String
	if current_turn == CurrentTurn.PLAYER1:
		player = "Player1"
	else:
		player = "Player2"
	grid_space_button_manager.show_available_spaces_for_wall_piece(player)

func _on_bomb_button_pressed() -> void:
	placeable_pieces_buttons.visible = false
	grid_space_button_manager.show_available_spaces_for_bomb()

func _on_grid_spaces_manager_finished_placing_pieces() -> void:
	turn_change(CurrentTurn.MOVEBALL)


func _on_grid_space_button_pushed(pushed_grid_position: Vector2i) -> void:
	pass # Replace with function body.
