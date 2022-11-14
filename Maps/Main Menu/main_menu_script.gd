extends Node2D

class_name MainMenu


#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Initialisation
#-------------------------------------------------------------------------------
func _ready():
	spawn_MainMenu()



#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_ui_main_menu_start_new_game() -> void:
	SceneLib.CONTINUE_GAME = false
	get_tree().change_scene_to_packed(SceneLib.MAIN_GAME_c)


func _on_ui_main_menu_continue_game_pressed():
	SceneLib.CONTINUE_GAME = true
	#load saved game scene and change scene to that
#-------------------------------------------------------------------------------
# UI Main Menu
#-------------------------------------------------------------------------------
func spawn_MainMenu():
	var main_menu = SceneLib.spawn_child(SceneLib.UI_MAIN_MENU, self)
	main_menu.btn_StartNewGame.pressed.connect(_on_ui_main_menu_start_new_game)
	main_menu.btn_ContinueGame.pressed.connect(_on_ui_main_menu_continue_game_pressed)

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------

