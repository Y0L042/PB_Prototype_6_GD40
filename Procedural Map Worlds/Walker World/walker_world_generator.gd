extends Node2D

class_name WalkerWorldGenerator

var borders := Rect2(0,0, 0,0)
var start_pos := Vector2.ZERO

@export var tilemap: TileMap
@export var map_size: Vector2
@export var total_steps: int = 500
@export var corridor_width: int = 3


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

func _init(map_data: MapDataObject) -> void:
	pass


func generate_map_blueprint(new_tilemap: TileMap = tilemap, new_size: Vector2 = map_size):
	borders.end = new_size
	start_pos = Vector2(round(new_size.x/2), round(new_size.y/2))
	walker = Walker.new(start_pos, borders)
	var map = walker.walk(total_steps)
	walker.queue_free()
	for location in map:
		new_tilemap.set_cell(0, location, 1, TILES.WHITE)
		for width in corridor_width:
			new_tilemap.set_cell(0, location + Vector2(width,0), 1, TILES.WHITE)
			new_tilemap.set_cell(0, location + Vector2(0,width), 1, TILES.WHITE)

	for x in new_size.x:
			for y in new_size.y:
				var pos: Vector2i = Vector2i(x, y)
				if new_tilemap.get_cell_atlas_coords(0, pos) != TILES.WHITE:
					new_tilemap.set_cell(0, pos, 1, TILES.BLACK)

	generate_map_borders(new_tilemap, new_size)

	new_tilemap.force_update(0)
	return new_tilemap



func generate_map_borders(new_tilemap: TileMap = tilemap, new_size: Vector2 = map_size):
	var b_size: int = 100
	for x in new_size.x + b_size*2:
		for y in new_size.y + b_size*2:
			var pos: Vector2i = Vector2i(x - b_size, y - b_size)
			if new_tilemap.get_cell_atlas_coords(0, pos) != TILES.WHITE:
				new_tilemap.set_cell(0, pos, 1, TILES.BLACK)



func clean_map(new_tilemap: TileMap, new_size: Vector2):
	for i in 6:
		for x in new_size.x:
			for y in new_size.y:
				var pos: Vector2i = Vector2i(x, y)
				var cell_terrain = new_tilemap.get_cell_atlas_coords(0, pos)
				var neighborcount: int = 0
				for offset in isurrounding_tiles:
					if Rect2(0,0, new_size.x,new_size.y).has_point(offset+pos):
						if new_tilemap.get_cell_atlas_coords(0, offset+pos) == cell_terrain:
							neighborcount += 1
				if neighborcount < 1:
					if new_tilemap.get_cell_atlas_coords(0, pos) == TILES.WHITE:
						new_tilemap.set_cell(0, pos, 1, TILES.BLACK)
					else:
						new_tilemap.set_cell(0, pos, 1, TILES.WHITE)


func populate_map_blueprint():
	pass


func get_start_room_pos():
	return walker.rooms.front() * 64 # x is block size

func get_end_room_pos():
	return walker.get_end_room() * 64
