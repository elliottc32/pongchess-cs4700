extends Node
@export var game: Node
@export var mainmenu_ui: Control
@export var setupmenu_ui: Control
@export var gamepaused_ui: Control
enum GameState {MAIN_MENU, SETUP_MENU, GAME, GAME_PAUSED}
var current_gamestate: GameState
var player1: String #Human or COM
var player2: String #Human or COM

func _ready() -> void:
	game.turn_invisible()
	mainmenu_ui.visible = false
	setupmenu_ui.visible = false
	gamepaused_ui.visible = false
	enter_mainmenu()

func change_state(destination: GameState):
	match current_gamestate:
		GameState.MAIN_MENU:
			exit_mainmenu()
			match destination:
				GameState.SETUP_MENU:
					enter_setupmenu()
				_:
					assert(false, "MainMenu tried to enter an impossible state.")
		GameState.SETUP_MENU:
			exit_setupmenu()
			match destination:
				GameState.MAIN_MENU:
					enter_mainmenu()
				GameState.GAME:
					enter_game()
				_:
					assert(false, "SetupMenu tried to enter an impossible state.")
		GameState.GAME:
			match destination:
				GameState.GAME_PAUSED:
					enter_gamepaused()
				_:
					assert(false, "Game(Menu) tried to enter an impossible state.")
		GameState.GAME_PAUSED:
			exit_gamepaused()
			match destination:
				GameState.GAME:
					pass #Not temporary, we literally want to do nothing
				GameState.MAIN_MENU:
					exit_game()
					enter_mainmenu()
				_:
					assert(false, "GamePaused tried to enter an impossible state.")

func enter_mainmenu() -> void:
	current_gamestate = GameState.MAIN_MENU
	mainmenu_ui.visible = true

func exit_mainmenu() -> void:
	mainmenu_ui.visible = false
	
func enter_setupmenu() -> void:
	current_gamestate = GameState.SETUP_MENU
	setupmenu_ui.visible = true

func exit_setupmenu() -> void:
	setupmenu_ui.visible = false

func enter_game() -> void:
	current_gamestate = GameState.GAME
	game.turn_visible()
	game.new_game(player1, player2)

func exit_game() -> void:
	game.turn_invisble()

func enter_gamepaused() -> void:
	current_gamestate = GameState.GAME_PAUSED
	#pause game variable
	gamepaused_ui.visible = true

func exit_gamepaused() -> void:
	gamepaused_ui.visible = false

#-----Signals---------

func _on_main_menu_ui_start_button_pressed() -> void:
	change_state(GameState.SETUP_MENU)

func _on_setup_menu_ui_begin_match_button_pressed(p1: String, p2: String) -> void:
	player1 = p1
	player2 = p2
	change_state(GameState.GAME)
