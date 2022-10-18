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
@export var tilemap: TileMap

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var TINYKEEP_ROOM: PackedScene = load("res://Procedural Map Worlds/TinyKeep World/room.tscn")

var path: AStar2D
var start_room
var end_room
var play_mode: bool = false
var rooms_array: Array

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

signal gen_complete
#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func tinykeep_setup(map_data: MapDataObject) -> void:
	tile_size = map_data.tinykeep_tile_size
	num_rooms = map_data.tinykeep_num_rooms
	min_size = map_data.tinykeep_min_size
	max_size = map_data.tinykeep_max_size
	hspread = map_data.tinykeep_hspread
	cull = map_data.tinykeep_cull
	tilemap = map_data.global_tilemap


func generate_map_blueprint():
	randomize()
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
#		var room = SceneLib.TINYKEEP_ROOM.instantiate()
		var room = TINYKEEP_ROOM.instantiate()
		get_tree().get_root().call_deferred("add_child", room)
		var width = new_min_size + randi() % (new_max_size - new_min_size)
		var height = new_min_size + randi() % (new_max_size - new_min_size)
		room.call_deferred("make_room", pos, Vector2(width, height) * new_tile_size)
	# wait for movement to stop
	var pause_time: float = 2.5
	await get_tree().create_timer(pause_time).timeout
	# cull rooms based on odds
	#																		add second method of culling based on room size
	var room_positions: Array
	for room in get_tree().get_root().get_children():
		if room.is_in_group("TinyKeepRoom"):
			if randf() <= new_cull:
				room.queue_free()
			else:
				room.set_freeze_mode(RigidBody2D.FREEZE_MODE_STATIC)
				room_positions.append(room.position)
				rooms_array.append(room)
	path = find_min_span_tree_astar(room_positions)
	make_map()




func find_min_span_tree_astar(room_positions: Array):
	# Prim's algorithm:
	# Given an array of positions (nodes), generates a minimum spanning tree
	# Returns an AStar object
# Initialize the AStar and add the first point
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), room_positions.pop_front())

	# Repeat until no more nodes remain
	while room_positions:
		var min_dist = INF  # Minimum distance found so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through the points in the path
		for p1 in path.get_point_count():
			var point1 = path.get_point_position(p1)
			# Loop through the remaining nodes in the given array
			for p2 in room_positions:
				# If the node is closer, make it the closest
				if point1.distance_to(p2) < min_dist:
					min_dist = point1.distance_to(p2)
					min_p = p2
					p = point1

		# Insert the resulting node into the path and add its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		room_positions.erase(min_p)
	return path



func find_min_span_tree_delaunay(room_positions: Array):
	var delaunay_points = Geometry2D.triangulate_delaunay(room_positions)
	for triangle_index in delaunay_points.size() / 3 :
		var triangle_rooms: Array
		for index in 3:
			var point = delaunay_points[(triangle_index * 3) + index]
			triangle_rooms.append(point)
	return path



func make_map():
	# Create a TileMap from the generated rooms and path
	tilemap.clear()
	find_start_room()
	find_end_room()

	# Fill TileMap with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in rooms_array:
		var room_rect = Rect2(room.position-room.size, room.collshape.shape.extents*2)
		full_rect = full_rect.merge(room_rect)
	var topleft = tilemap.local_to_map(full_rect.position)
	var bottomright = tilemap.local_to_map(full_rect.end)
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			tilemap.set_cell(0, Vector2i(x, y), 1, TILES.BLACK)

	# Carve rooms
	var corridors: Array  # One corridor per connection
	for room in rooms_array:
		var s = (room.size / tile_size).floor()
		var pos = tilemap.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
#				tilemap.set_cell(ul.x + x, ul.y + y, 0)
				tilemap.set_cell(0, Vector2i(ul.x + x, ul.y + y), 1, TILES.WHITE)
		# Carve connecting corridor
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = tilemap.local_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = tilemap.local_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)
	gen_complete.emit()


func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
#		tilemap.set_cell(x, x_y.y, 0)
		tilemap.set_cell(0, Vector2i(x, x_y.y), 1, TILES.WHITE)
#		tilemap.set_cell(x, x_y.y + y_diff, 0)  # widen the corridor
		tilemap.set_cell(0, Vector2i(x, x_y.y + y_diff), 1, TILES.WHITE)
	for y in range(pos1.y, pos2.y, y_diff):
#		tilemap.set_cell(y_x.x, y, 0)
		tilemap.set_cell(0, Vector2i(y_x.x, y), 1, TILES.WHITE)
#		tilemap.set_cell(y_x.x + x_diff, y, 0)
		tilemap.set_cell(0, Vector2i(y_x.x + x_diff, y), 1, TILES.WHITE)


func find_start_room():
	var min_x = INF
	for room in rooms_array:
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x


func find_end_room():
	var max_x = -INF
	for room in rooms_array:
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x

#-------------------------------------------------------------------------------
# Draw
#-------------------------------------------------------------------------------
func _draw():
	for room in rooms_array:
		draw_rect(Rect2(room.get_global_position() - room.size, room.size*2), Color(0, 1, 0), false)
	if path:
		for p in path.get_point_count():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y),
				Vector2(cp.x, cp.y),
				Color(1, 1, 0, 1), 15, true)
