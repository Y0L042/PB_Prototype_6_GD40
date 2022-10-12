extends Control



func _ready() -> void:
	pause()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(SceneLib.MAIN_MENU)

func _on_resume_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	quit()



func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func unpause():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func quit():
	get_tree().quit()

