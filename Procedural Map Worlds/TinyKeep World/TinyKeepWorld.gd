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
@export var cull: float = 0.75

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var path: AStarGrid2D #AStar2D
var start_room
var end_room
var play_mode: bool = false
var rooms_array: Array

#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
#	randomize()
	make_rooms()

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	queue_redraw()



#-------------------------------------------------------------------------------
# Make Rooms
#-------------------------------------------------------------------------------
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


	# wait for movement to stop
	var pause_time: float = 2.5
	await get_tree().create_timer(pause_time).timeout

	# cull rooms based on odds
	#																		add second method of culling based on room size
	var room_positions: PackedVector2Array
	for room in get_tree().get_root().get_children():
		if room.is_in_group("TinyKeepRoom"):
			if randf() <= new_cull:
				room.queue_free()
			else:
				room.set_freeze_mode(RigidBody2D.FREEZE_MODE_STATIC)
				rooms_array.append(room)
				room_positions.append(room.position)

	path = find_min_span_tree_astar(room_positions)

func find_min_span_tree_astar(room_positions: PackedVector2Array):
	# Prim's algorithm:
	# Given an array of positions (nodes), generates a minimum spanning tree
	# Returns an AStar object
	pass

func find_min_span_tree_delaunay(room_positions: PackedVector2Array):
	pass



#-------------------------------------------------------------------------------
# Draw
#-------------------------------------------------------------------------------
func _draw():
	for room in get_tree().get_root().get_children():
		if room.is_in_group("TinyKeepRoom"):
			draw_rect(Rect2(room.get_global_position() - room.size, room.size*2), Color(0, 1, 0), false)
