extends Node2D

class_name  MainGame

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var map_manager: MapManager


var player_party_manager: PlayerPartyManager
@export var player_starting_actors := 1


var pause_menu = SceneLib.spawn_child(SceneLib.UI_PAUSE_MENU, self)
var current_ui_menu
var choice_menu

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready():
	if SceneLib.CONTINUE_GAME:
		SceneLib.load_game()
	else:
		map_manager = MapManager.new()
		map_manager.spawn_first_level()
	spawn_player_manager()


func spawn_player_manager():
	player_party_manager = SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	map_manager.current_map.spawn_player_party(player_party_manager, player_starting_actors)
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
#	end_game(victory)

func give_reward(new_weapon):
	player_party_manager.give_actors_more_weapons(new_weapon)





func _process_choice(choice):

	choice_menu.queue_free()



