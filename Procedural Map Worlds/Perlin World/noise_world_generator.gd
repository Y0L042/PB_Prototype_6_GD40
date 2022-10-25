extends Node2D

class_name NoiseWorldGenerator


#-------------------------------------------------------------------------------
# Interface Properties
#-------------------------------------------------------------------------------
@export var white_tile_filter: float = 0.15
@export var size: Vector2
@export var tilemap: TileMap

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var default_noise_resource = preload("res://Procedural Map Worlds/Perlin World/perlin_world_noise.tres")
var WIDTH: int = default_noise_resource.width
var HEIGHT: int = default_noise_resource.height
var default_noise = default_noise_resource.get_noise()
var areas = []

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

const isurrounding_tiles: PackedVector2Array = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1, 0),                  Vector2i(1, 0),
	Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1),
]

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init(map_data: MapDataObject) -> void:
	tilemap = map_data.global_tilemap
	size = map_data.global_map_size
	# white_tile_filter = map_data.something...


#-------------------------------------------------------------------------------
# Blueprint Generation Functions
#-------------------------------------------------------------------------------
func generate_map_blueprint(new_tilemap: TileMap = tilemap, new_size: Vector2 = size, noise = default_noise):
	default_noise_resource.width = new_size.x
	default_noise_resource.height = new_size.y
	noise.seed = 2

	for x in size.x:
		for y in size.y:
			var tile = get_tile_index(noise.get_noise_2d(float(x), float(y)))
			new_tilemap.set_cell(0, Vector2i(x, y), 1, tile)

	return new_tilemap


func generate_map_borders(new_tilemap: TileMap = tilemap, new_size: Vector2 = size):
	var b_size: int = 100
	for x in new_size.x + b_size*2:
		for y in new_size.y + b_size*2:
			var pos: Vector2i = Vector2i(x - b_size, y - b_size)
			if new_tilemap.get_cell_atlas_coords(0, pos) != TILES.WHITE:
				new_tilemap.set_cell(0, pos, 1, TILES.BLACK)




func clean_map(new_tilemap: TileMap = tilemap, new_size: Vector2 = size):
	for i in 3:
		for x in new_size.x:
			for y in new_size.y:
				var pos: Vector2i = Vector2i(x, y)
				var cell_terrain = new_tilemap.get_cell_atlas_coords(0, pos)
				var neighborcount: int = 0
				for offset in isurrounding_tiles:
					if Rect2(0,0, new_size.x,new_size.y).has_point(offset+pos):
						if new_tilemap.get_cell_atlas_coords(0, offset+pos) == cell_terrain:
							neighborcount += 1
				if neighborcount < 3:
					if new_tilemap.get_cell_atlas_coords(0, pos) == TILES.WHITE:
						new_tilemap.set_cell(0, pos, 1, TILES.BLACK)
					else:
						new_tilemap.set_cell(0, pos, 1, TILES.WHITE)


func populate_map_blueprint():
	pass

class CustomArray:
	pass

func poisson_disc_sampler(new_tilemap: TileMap = tilemap):
	var new_size = tilemap.get_used_rect()
	var radius: int = 10 # radius of disks
	var k: int = 30 # sample limit before rejection
	var grid: Array
	var width: float = radius / sqrt(2)
	var cols = floor(new_size.x / width)
	var rows = floor(new_size.y / width)

	var sample_points: Array = [[],[]]



	# Step 0: Set sample_points array to 0 (it also sets size)
	for x in new_size.x:
		sample_points.append([])
		for y in new_size.y:
			sample_points[x].append(0)

	# Step 1: Sample random point
	var tempbool := true
	while tempbool:
		var x: int = randi_range(-new_size.x, new_size.x)
		var y: int = randi_range(-new_size.y, new_size.y)
		var pos := Vector2i(x, y)
		if new_tilemap.get_cell_atlas_coords(0, pos) == SceneLib.TILES.WHITE:
			sample_points[x][y] = 1
			var active_sample = sample_points[x][y]
			tempbool = false

	# Step 2: Get a random sample in a range of focus point
	while !sample_points.is_empty():
		var x: int = randi_range(-new_size.x, new_size.x)
		var y: int = randi_range(-new_size.y, new_size.y)
		var active_point := Vector2i(x, y)
		var k: int = 5 #?
		for index in k:
			var rand_vec = Vector2(randf_range(-360, 360), randf_range(-360, 360)).normalized()
			rand_vec *= randi_range(radius, 3*radius)
			rand_vec = rand_vec.round()




func get_tile_index(noise_sample):
	if noise_sample < white_tile_filter:
		return TILES.WHITE
	return TILES.BLACK

func return_map_data():
	return areas
