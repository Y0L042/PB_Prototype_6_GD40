extends Control




func _on_start_new_game_pressed() -> void:
	start_new_game()

func _on_quit_pressed() -> void:
	quit()



func start_new_game():
	get_tree().change_scene_to_packed(SceneLib.OUTDOOR_WORLD)

func quit():
	get_tree().quit()
