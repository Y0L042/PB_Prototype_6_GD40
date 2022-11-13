extends Node2D

class_name  MainGame

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
enum DOCKS {E, S, W, N}
var spawned_level_list: Array
var future_level_list: Array

@onready var STARTING_WORLD = SceneLib.WORLD.WASTELAND
@onready var current_world = STARTING_WORLD
@onready var current_map

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
	generate_future_level_list()
	spawn_first_level()
	spawn_player_manager()

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



func spawn_player_manager():
	player_party_manager = SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	player_party_manager.spawn(spawned_level_list[0].player_spawn_pos, player_starting_actors)
	player_party_manager.allActorsDead.connect(_all_player_actors_dead, CONNECT_ONE_SHOT)



#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _all_player_actors_dead(player):
	var defeat := "Defeat"
	end_game(defeat)

func end_game(end_state):
	var ui_game_end = SceneLib.spawn_child(SceneLib.UI_GAME_END, self)
	ui_game_end.condition_label.set_text(end_state)


#level condition signal emits and triggers choice for next levels
func _level_ConditionSignal():
	print("Condition met")
	give_reward(SceneLib.WPN_SWORD)
#	current_map.ConditionSignal.disconnect(_level_ConditionSignal)
	# load next level in list, otherwise victory
	if !future_level_list.is_empty():
		load_next_level(future_level_list)
	else:
		var victory := "Victory"
		end_game(victory)

func give_reward(new_weapon):
	player_party_manager.give_actors_more_weapons(new_weapon)


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
