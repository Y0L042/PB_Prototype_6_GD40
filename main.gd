extends Node2D

class_name Main


#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var player_party_manager: PlayerPartyManager
var level_list: Array
var current_level

var pause_menu = SceneLib.spawn_child(SceneLib.UI_PAUSE_MENU, self)
var current_menu



#-------------------------------------------------------------------------------
# Initialisation
#-------------------------------------------------------------------------------
func _ready():
	current_menu = spawn_MainMenu()
	

func _on_ui_main_menu_start_new_game() -> void:
	var first_level = SceneLib.leveled_list_maps[0]
	var starting_level = spawn_first_level(first_level)
	spawn_player_manager()
	current_menu.queue_free()
	
	
func spawn_first_level(new_level):
	new_level = SceneLib.spawn_child(new_level, self)
	new_level.ConditionSignal.connect(_level_ConditionSignal)
	level_list.append(new_level)
	current_level = new_level


func spawn_player_manager():
	player_party_manager = SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	player_party_manager.spawn(level_list[0].player_spawn_pos, 10)



#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------

#level condition signal emits and triggers choice for next levels
func _level_ConditionSignal():
	print("Condition met")
	current_level.ConditionSignal.disconnect(_level_ConditionSignal)
	var choice_menu = SceneLib.spawn_child(SceneLib.UI_ENDOFLEVELCHOICE, self)
	# enable circle portals or whatever
	
	

# next chosen level is placed on map
func place_new_map(new_map):
	new_map = SceneLib.spawn_child(new_map, self)
	new_map.ConditionSignal.connect(_level_ConditionSignal)
	level_list.append(new_map)


#-------------------------------------------------------------------------------
# UI Main Menu
#-------------------------------------------------------------------------------
func spawn_MainMenu():
	var main_menu = SceneLib.spawn_child(SceneLib.UI_MAIN_MENU, self)
	main_menu.btn_StartNewGame.pressed.connect(_on_ui_main_menu_start_new_game)
#	main_menu.btn_Quit.pressed.connect(#quit)
	
	return main_menu
	
#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------




#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------

