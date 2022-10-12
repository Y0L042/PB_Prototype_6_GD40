extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_new_game_pressed() -> void:
	start_new_game()

func _on_quit_pressed() -> void:
	quit()



func start_new_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_packed(SceneLib.OUTDOOR_WORLD)

func quit():
	get_tree().quit()
