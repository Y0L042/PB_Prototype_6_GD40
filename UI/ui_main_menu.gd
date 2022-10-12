extends Control




func _on_start_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(SceneLib.OUTDOOR_WORLD)
