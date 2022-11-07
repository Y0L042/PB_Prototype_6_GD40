extends Node2D

class_name Main

var player_party_manager: PlayerPartyManager
var level_list: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass






#-------------------------------------------------------------------------------
# Initialisation
#-------------------------------------------------------------------------------
func _on_ui_main_menu_start_new_game(main_menu) -> void:
	var first_level = SceneLib.STARTING_MAP
	var starting_level = change_level(main_menu, first_level, self)

#	var pause_time: float = 2.5
#	await get_tree().create_timer(pause_time).timeout

	spawn_player_manager()


func spawn_player_manager():
	player_party_manager = SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	player_party_manager.spawn(level_list[0].player_manager_spawn_pos, 10)






#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func change_level(old_level, new_level, parent):
	old_level.queue_free()
	new_level = SceneLib.spawn_child(new_level, self)
	level_list.append(new_level)
	return new_level


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------
#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		pause_menu.pause()
