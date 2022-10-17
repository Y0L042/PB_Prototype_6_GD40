extends Node2D


class_name TinyKeepWorldGenerator

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var tile_size: int = 64
@export var num_rooms: int = 50
@export var min_size: int = 6
@export var max_size: int = 15
@export var hspread: int = 400
@export var cull: float = 0.5

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var path: AStarGrid2D #AStar2D
var start_room
var end_room
var play_mode: bool = false
var rooms_array: Array

func _ready() -> void:
	randomize()
	make_rooms()

func make_rooms(
	new_num_rooms: int = num_rooms,
	new_hspread: int = hspread,
	new_min_size: int = min_size,
	new_max_size: int = max_size,
	new_tile_size: int = tile_size,
	new_cull: float = cull,
):
	for index in range(new_num_rooms):
		var pos = Vector2(randi_range(-new_hspread, new_hspread), 0)
		var room = SceneLib.TINYKEEP_ROOM.instantiate()
		get_tree().get_root().call_deferred("add_child", room)
		var width = new_min_size + randi() % (new_max_size - new_min_size)
		var height = new_min_size + randi() % (new_max_size - new_min_size)
		room.call_deferred("make_room", pos, Vector2(width, height) * new_tile_size)
#		room.make_room(pos, Vector2(width, height) * new_tile_size)
		rooms_array.append(room)


	# wait for movement to stop

	# cull rooms
	var room_positions: PackedVector2Array
	for room in rooms_array:
		if randf() < new_cull:
			rooms_array.pop_front()
		else:
			room.set_freeze_mode(RigidBody2D.FREEZE_MODE_STATIC)
			room_positions.append(room.position)
	path = find_min_span_tree(room_positions)

func find_min_span_tree(room_positions: PackedVector2Array):
	pass
