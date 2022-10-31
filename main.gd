extends Node2D

class_name Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_level(old_level, new_level, parent):
	old_level.queue_free()
	SceneLib.spawn_child(new_level, self)


func _on_ui_main_menu_start_new_game(main_menu) -> void:
	var new_level = SceneLib.STARTING_MAP
	change_level(main_menu, new_level, self)
	instantiate_player()

#-------------------------------------------------------------------------------
# Initialisation
#-------------------------------------------------------------------------------
func instantiate_player():
	SceneLib.spawn_child(SceneLib.PLAYER_PARTY, self)
	# set player position
	# spawn soldiers


#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------
#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_cancel"):
#		pause_menu.pause()
