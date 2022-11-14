extends Node

class_name MapManager

enum DOCKS {E, S, W, N}
var spawned_level_list: Array
var future_level_list: Array

@onready var STARTING_WORLD = SceneLib.WORLD.WASTELAND
@onready var current_world = STARTING_WORLD
@onready var current_map

func generate_future_level_list():
	pass

func spawn_first_level():
	STARTING_WORLD = SceneLib.WORLD.WASTELAND
	current_world = STARTING_WORLD
	current_map = current_world.LVL_ORDER[0]
	var first_level = current_map
	first_level = SceneLib.spawn_child(first_level, self)
	first_level.ConditionSignal.connect(_level_ConditionSignal, CONNECT_ONE_SHOT)
	spawned_level_list.append(first_level)
	current_map = first_level


func load_next_level(new_future_level_list: Array):
#	var choice1 = new_future_level_list.pop_front().instantiate()
#
#	var choice2 = null
#	if !new_future_level_list.is_empty():
#		choice2 = new_future_level_list.pop_front()

	choice_menu = SceneLib.spawn_child(SceneLib.UI_ENDOFLEVELCHOICE, self)
#	choice_menu.add_level_choice_button(choice1.level_meta_data)
#	if choice2:
#		choice_menu.add_level_choice_button(choice2.level_meta_data)

	# enable circle portals or whatever
	choice_menu.EoL_choice.connect(_process_choice)
	await choice_menu.EoL_choice


# next chosen level is placed on map
func place_new_map(new_map, location):
	new_map = SceneLib.spawn_child(new_map, self)
	var current_map_dock_pos: Vector2 = current_map.docks[location].get_global_position()
	var new_map_dock_pos: Vector2 = new_map.docks[get_opposite_dock(location)].get_global_position()
	var new_map_dock_offset: Vector2 = new_map.get_global_position() - new_map_dock_pos
	var new_map_pos: Vector2 = current_map_dock_pos + new_map_dock_offset
	new_map.set_global_position(new_map_pos)
	new_map.ConditionSignal.connect(_level_ConditionSignal)
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
