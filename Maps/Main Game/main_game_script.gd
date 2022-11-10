extends Node2D

class_name  MainGame

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
enum DOCKS {E, S, W, N}
var level_list: Array
var current_map

var player_party_manager: PlayerPartyManager
@export var player_starting_actors := 1


var pause_menu = SceneLib.spawn_child(SceneLib.UI_PAUSE_MENU, self)
var current_ui_menu
var choice_menu

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready():
	# Load saved data
	SceneLib.load_game()
	spawn_first_level()
	spawn_player_manager()


func spawn_first_level():
	var first_level = SceneLib.leveled_list_maps[0]
	first_level = SceneLib.spawn_child(first_level, self)
	first_level.ConditionSignal.connect(_level_ConditionSignal)
	level_list.append(first_level)
	current_map = first_level



func spawn_player_manager():
	player_party_manager = SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	player_party_manager.spawn(level_list[0].player_spawn_pos, player_starting_actors)

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------

#level condition signal emits and triggers choice for next levels
func _level_ConditionSignal():
	print("Condition met")
	current_map.ConditionSignal.disconnect(_level_ConditionSignal)
	choice_menu = SceneLib.spawn_child(SceneLib.UI_ENDOFLEVELCHOICE, self)
	# enable circle portals or whatever
	choice_menu.EoL_choice.connect(_process_choice)

func _process_choice(choice):
	if choice == 1:
		place_new_map(SceneLib.leveled_list_maps[1], DOCKS.E)
	if choice == 2:
		place_new_map(SceneLib.leveled_list_maps[1], DOCKS.S)
	choice_menu.queue_free()


# next chosen level is placed on map
func place_new_map(new_map, location):
	new_map = SceneLib.spawn_child(new_map, self)
	var current_map_dock_pos: Vector2 = current_map.docks[location].get_global_position()
	var new_map_dock_pos: Vector2 = new_map.docks[get_opposite_dock(location)].get_global_position()
	var new_map_dock_offset: Vector2 = new_map.get_global_position() - new_map_dock_pos
	var new_map_pos: Vector2 = current_map_dock_pos + new_map_dock_offset
	new_map.set_global_position(new_map_pos)
	new_map.ConditionSignal.connect(_level_ConditionSignal)
	level_list.append(new_map)
	current_map = new_map


func get_opposite_dock(current_dock: int) -> int:
	if current_dock == 0:
		return 2
	if current_dock == 1:
		return 3
	if current_dock == 2:
		return 0
	if current_dock == 3:
		return 1
	return -1
