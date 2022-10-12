extends Node2D

class_name WalkerWorldGenerator

@export var borders := Rect2(0, 0, 38,21)
@export var start_pos := Vector2.ZERO
@export var total_steps: int = 500

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

var walker: Walker

func _ready() -> void:
	pass
#	generate_map()


func generate_map(tilemap: TileMap, size: Vector2 = Vector2.ZERO):
	borders.end = size
	walker = Walker.new(start_pos, borders)
	var map = walker.walk(total_steps)
	walker.queue_free()
	for location in map:
		tilemap.set_cell(0, location, 1, TILES.WHITE)
	tilemap.force_update(0)
	return tilemap

func get_start_room_pos():
	return walker.rooms.front() * 64 # x is block size

func get_end_room_pos():
	return walker.get_end_room() * 64
