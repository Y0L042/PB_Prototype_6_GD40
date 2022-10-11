@tool
extends EditorPlugin

class_name FDB


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

func create_itemlist(pos: Vector2, text):
	var debug = ItemList.new()
	debug.rect_position = Vector2(50,100)
	debug.text = text
	add_child(debug)
