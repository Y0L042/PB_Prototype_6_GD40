extends Node2D

class_name NoiseWorldGenerator

#@onready var noise_sprite = %Noise
#@onready var noise_texture = noise_sprite.get_texture()
#@onready var WIDTH: int = noise_texture.width
#@onready var HEIGHT: int = noise_texture.height
#@onready var noise_source = noise_texture.get_noise()

@export var white_tile_filter: float = 0.15

var default_noise_resource = preload("res://Procedural Map Worlds/Perlin World/perlin_world_noise.tres")
var WIDTH: int = default_noise_resource.width
var HEIGHT: int = default_noise_resource.height
var default_noise = default_noise_resource.get_noise()

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

const isurrounding_tiles: PackedVector2Array = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1, 0),                  Vector2i(1, 0),
	Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1),
]

func _ready() -> void:
	pass
#	generate_map(noise_source)
#	noise_sprite.set_visible(false)



func generate_map(tilemap: TileMap, size: Vector2 = Vector2.ZERO, noise = default_noise):
	default_noise_resource.width = size.x
	default_noise_resource.height = size.y
	noise.seed = 2

	for x in size.x:
		for y in size.y:
			var tile = get_tile_index(noise.get_noise_2d(float(x), float(y)))
			tilemap.set_cell(0, Vector2i(x, y), 1, tile)

	generate_map_borders(tilemap, size)

	return tilemap


func generate_map_borders(tilemap: TileMap, size: Vector2):
	var b_size: int = 100
	for x in size.x + b_size*2:
		for y in size.y + b_size*2:
			var pos: Vector2i = Vector2i(x - b_size, y - b_size)
			if tilemap.get_cell_atlas_coords(0, pos) != TILES.WHITE:
				tilemap.set_cell(0, pos, 1, TILES.BLACK)




func clean_map(tilemap: TileMap, size: Vector2):
	for i in 3:
		for x in size.x:
			for y in size.y:
				var pos: Vector2i = Vector2i(x, y)
				var cell_terrain = tilemap.get_cell_atlas_coords(0, pos)
				var neighborcount: int = 0
				for offset in isurrounding_tiles:
					if Rect2(0,0, size.x,size.y).has_point(offset+pos):
						if tilemap.get_cell_atlas_coords(0, offset+pos) == cell_terrain:
							neighborcount += 1
				if neighborcount < 3:
					if tilemap.get_cell_atlas_coords(0, pos) == TILES.WHITE:
						tilemap.set_cell(0, pos, 1, TILES.BLACK)
					else:
						tilemap.set_cell(0, pos, 1, TILES.WHITE)


func get_tile_index(noise_sample):
	if noise_sample < white_tile_filter:
		return TILES.WHITE
	return TILES.BLACK


