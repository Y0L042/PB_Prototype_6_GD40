extends Node2D

class_name Main


#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var player_party_manager: PlayerPartyManager
var level_list: Array






#-------------------------------------------------------------------------------
# Initialisation
#-------------------------------------------------------------------------------
func _on_ui_main_menu_start_new_game(main_menu) -> void:
	var first_level = SceneLib.leveled_list_maps[0]
	var starting_level = spawn_first_level(main_menu, first_level, self)
	spawn_player_manager()
	
func spawn_first_level(old_level, new_level, parent):
	old_level.queue_free()
	new_level = SceneLib.spawn_child(new_level, self)
	new_level.ConditionSignal.connect(_level_ConditionSignal)
	level_list.append(new_level)


func spawn_player_manager():
	player_party_manager = SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	player_party_manager.spawn(level_list[0].player_spawn_pos, 10)



#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------

func _level_ConditionSignal():
	print("Condition met")
	pass


func place_new_map(new_map):
	
	new_map = SceneLib.spawn_child(new_map, self)
	level_list.append(new_map)

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------




#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------
#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		pause_menu.pause()
