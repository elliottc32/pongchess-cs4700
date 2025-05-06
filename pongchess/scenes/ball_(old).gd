class_name Ball
extends RigidBody2D

@export var ball_speed: float
@export var move_speed_timer: Timer
enum BounceDirection {UPRIGHT, UPLEFT, DOWNRIGHT, DOWNLEFT}
var bounce_direction: BounceDirection
var grid_position: Vector2i
var can_move: bool
var next_position: Vector2
signal point_scored(player_who_scored: String)
signal midpoint_crossed(ball_bounce_direction: BounceDirection)

func _ready() -> void:
	move_speed_timer.wait_time = ball_speed
	move_ball()

func initialize_ball(ball_grid_position: Vector2i, ball_bounce_direction: BounceDirection):
	grid_position = Vector2(ball_grid_position)
	bounce_direction = ball_bounce_direction
	can_move = true

func move_ball() -> void:
	if can_move == true:
		match bounce_direction:
			BounceDirection.UPRIGHT:
				grid_position += Vector2i(1,-1)
			BounceDirection.UPLEFT:
				grid_position += Vector2i(-1,-1)
			BounceDirection.DOWNRIGHT:
				grid_position += Vector2i(1,1)
			BounceDirection.DOWNLEFT:
				grid_position += Vector2i(-1,1)
		next_position = grid_position * 8
		position = next_position
		move_speed_timer.start()

func move_ball_two() -> void:
	if next_position.y < -112:
		print(str(next_position.y))
		point_scored.emit("Top")
		queue_free()
	elif next_position.y > 112:
		point_scored.emit("Bottom")
		queue_free()
	elif next_position.y == 0:
		can_move = false
		midpoint_crossed.emit(bounce_direction)
	move_ball()

func _on_piece_bounce(bounce: String) -> void:
	#Piece bounces are either "Horizontal" or "Vertical"
	var prev_bounce_direction: BounceDirection = bounce_direction
	if bounce == "Horizontal":
		match prev_bounce_direction:
			BounceDirection.UPRIGHT:
				bounce_direction = BounceDirection.DOWNRIGHT
			BounceDirection.UPLEFT:
				bounce_direction = BounceDirection.DOWNLEFT
			BounceDirection.DOWNRIGHT:
				bounce_direction = BounceDirection.UPRIGHT
			BounceDirection.DOWNLEFT:
				bounce_direction = BounceDirection.UPLEFT
	elif bounce == "Vertical":
		match prev_bounce_direction:
			BounceDirection.UPRIGHT:
				bounce_direction = BounceDirection.UPLEFT
			BounceDirection.UPLEFT:
				bounce_direction = BounceDirection.UPRIGHT
			BounceDirection.DOWNRIGHT:
				bounce_direction = BounceDirection.DOWNLEFT
			BounceDirection.DOWNLEFT:
				bounce_direction = BounceDirection.DOWNRIGHT

func _on_move_speed_timer_timeout() -> void:
	move_ball_two()
