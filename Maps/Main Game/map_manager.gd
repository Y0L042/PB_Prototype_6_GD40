extends Node

class_name MapManager

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
enum DOCKS {E, S, W, N}
var spawned_level_list: Array
var future_level_list: Array

var STARTING_WORLD = SceneLib.WORLD.WASTELAND
var current_world = STARTING_WORLD
var current_map

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Continue Game
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# New Game
#-------------------------------------------------------------------------------
func spawn_first_level():
	current_map = current_world.LVL_ORDER[0]
	current_map = SceneLib.spawn_child(current_map, self)
#	current_map.ConditionSignal.connect(_level_ConditionSignal, CONNECT_ONE_SHOT)
	spawned_level_list.append(current_map)




#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func load_next_level():
	pass


# next chosen level is placed on map
func place_new_map(new_map, location):
	new_map = SceneLib.spawn_child(new_map, self)
	var current_map_dock_pos: Vector2 = current_map.docks[location].get_global_position()
	var new_map_dock_pos: Vector2 = new_map.docks[get_opposite_dock(location)].get_global_position()
	var new_map_dock_offset: Vector2 = new_map.get_global_position() - new_map_dock_pos
	var new_map_pos: Vector2 = current_map_dock_pos + new_map_dock_offset
	new_map.set_global_position(new_map_pos)
#	new_map.ConditionSignal.connect(_level_ConditionSignal)
	spawned_level_list.append(new_map)
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
