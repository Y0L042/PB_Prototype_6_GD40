extends Node

class_name MapManager

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
signal ConditionSignal

var main_game: MainGame

enum DOCKS {E, S, W, N}
var spawned_level_list: Array
var future_level_list: Array

var STARTING_WORLD = SceneLib.WORLD.WASTELAND
var current_world = STARTING_WORLD
var current_map
var map_index := 0

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _init(new_main_game) -> void:
	main_game = new_main_game

#-------------------------------------------------------------------------------
# Continue Game
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# New Game
#-------------------------------------------------------------------------------
func spawn_first_level():
		current_map = current_world.LEVEL_ORDER[map_index]
		current_map = SceneLib.spawn_child(current_map, main_game)
		current_map.set_main_game(main_game)
		current_map.debug() #erase_disabled_docks()
		map_index += 1
		current_map.ConditionSignal.connect(_level_ConditionSignal, CONNECT_ONE_SHOT)
		spawned_level_list.append(current_map)




#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _level_ConditionSignal():
	ConditionSignal.emit()

func spawn_next_level():
	#get random valid dock from current map
	#place new dock there
	#remove "used" dock, and disabled docks, from new map
	#connect signals and append to array, update map_index and set as current map

	if map_index <= current_world.LEVEL_ORDER.size() - 1:
		var new_map = current_world.LEVEL_ORDER[map_index]
		new_map = SceneLib.spawn_child(new_map, main_game)
		new_map.set_main_game(main_game)
		var random_dock = choose_random_dock(current_map)
		place_new_map(new_map, random_dock)
		new_map.docks[get_opposite_dock(random_dock)].queue_free()
		new_map.docks[get_opposite_dock(random_dock)] = null
		new_map.erase_disabled_docks()

		new_map.ConditionSignal.connect(_level_ConditionSignal, CONNECT_ONE_SHOT)
		current_map = new_map
		spawned_level_list.append(current_map)
		map_index += 1

	else:
		print("end of world, load next one")
		#signal end of world, or something




func choose_random_dock(map):
#	for dock_index in map.docks.size():
#		if map.docks[dock_index] != null:
#			return dock_index

	var docks_copy: Array = map.docks.duplicate()
	var return_dock
	docks_copy.shuffle()
	for dock in docks_copy:
		if dock != null:
			return_dock = dock
			break
	for dock in map.docks:
		if return_dock == dock:
			return map.docks.find(dock)
	return -1


func load_next_level():
	pass



# next chosen level is placed on map
func place_new_map(new_map, dock_index):
	var current_map_dock_pos: Vector2 = current_map.docks[dock_index].get_global_position()
	var new_map_dock_pos: Vector2 = new_map.docks[get_opposite_dock(dock_index)].get_global_position()
	var new_map_dock_offset: Vector2 = new_map.get_global_position() - new_map_dock_pos
	var new_map_pos: Vector2 = current_map_dock_pos + new_map_dock_offset
	new_map.set_global_position(new_map_pos)



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

