extends Control


@onready var condition_label: Label = %Condition

func _ready() -> void:
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(SceneLib.MAIN_GAME_c)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(SceneLib.MAIN_MENU_c)
