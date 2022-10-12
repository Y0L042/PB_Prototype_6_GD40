extends Control

@onready var canvas_layer = %CanvasLayer

func _ready() -> void:
	canvas_layer.set_visible(false)

func _on_main_menu_pressed() -> void:
	get_parent().queue_free()
	get_tree().change_scene_to_packed(SceneLib.MAIN_MENU)


func _on_resume_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	quit()



func pause():
	canvas_layer.set_visible(true)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func unpause():
	canvas_layer.set_visible(false)
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func quit():
	get_tree().quit()

