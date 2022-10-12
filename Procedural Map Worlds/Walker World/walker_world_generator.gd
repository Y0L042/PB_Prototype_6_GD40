extends Node2D

class_name WalkerWorldGenerator

var borders := Rect2(0,0, 0,0)
var start_pos := Vector2.ZERO
var total_steps: int = 500

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

const isurrounding_tiles: PackedVector2Array = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1, 0),                  Vector2i(1, 0),
	Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1),
]

var walker: Walker

func _ready() -> void:
	pass
#	generate_map()


func generate_map(tilemap: TileMap, size: Vector2 = Vector2.ZERO):
	var corridor_width: int = 3
	borders.end = size
	start_pos = Vector2(round(size.x/2), round(size.y/2))
	walker = Walker.new(start_pos, borders)
	var map = walker.walk(total_steps)
	walker.queue_free()
	for location in map:
		tilemap.set_cell(0, location, 1, TILES.WHITE)
		for width in corridor_width:
			tilemap.set_cell(0, location + Vector2(width,0), 1, TILES.WHITE)
			tilemap.set_cell(0, location + Vector2(0,width), 1, TILES.WHITE)

	for x in size.x:
			for y in size.y:
				var pos: Vector2i = Vector2i(x, y)
				if tilemap.get_cell_atlas_coords(0, pos) != TILES.WHITE:
					tilemap.set_cell(0, pos, 1, TILES.BLACK)

	generate_map_borders(tilemap, size)

	tilemap.force_update(0)
	return tilemap

func generate_map_borders(tilemap: TileMap, size: Vector2):
	var b_size: int = 100
	for x in size.x + b_size*2:
		for y in size.y + b_size*2:
			var pos: Vector2i = Vector2i(x - b_size, y - b_size)
			if tilemap.get_cell_atlas_coords(0, pos) != TILES.WHITE:
				tilemap.set_cell(0, pos, 1, TILES.BLACK)

func clean_map(tilemap: TileMap, size: Vector2):
	for i in 6:
		for x in size.x:
			for y in size.y:
				var pos: Vector2i = Vector2i(x, y)
				var cell_terrain = tilemap.get_cell_atlas_coords(0, pos)
				var neighborcount: int = 0
				for offset in isurrounding_tiles:
					if Rect2(0,0, size.x,size.y).has_point(offset+pos):
						if tilemap.get_cell_atlas_coords(0, offset+pos) == cell_terrain:
							neighborcount += 1
				if neighborcount < 1:
					if tilemap.get_cell_atlas_coords(0, pos) == TILES.WHITE:
						tilemap.set_cell(0, pos, 1, TILES.BLACK)
					else:
						tilemap.set_cell(0, pos, 1, TILES.WHITE)


func get_start_room_pos():
	return walker.rooms.front() * 64 # x is block size

func get_end_room_pos():
	return walker.get_end_room() * 64
