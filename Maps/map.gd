extends Node2D

@export var tilemap_size: Vector2 = Vector2(160, 90)

@onready var pause_menu = %"UI_Pause Menu"
@onready var world_tilemap: TileMap = %TileMap

var map_generators: Dictionary = {
	"noise_map": NoiseWorldGenerator.new(),
	"walker_map": WalkerWorldGenerator.new(),
}

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

#var noise_map_gen: NoiseWorldGenerator = NoiseWorldGenerator.new()
#var walker_map_gen: WalkerWorldGenerator = WalkerWorldGenerator.new()

#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func _ready() -> void:
	# Generate map
	generate_map(map_generators.noise_map, world_tilemap)
	clean_map(world_tilemap, tilemap_size)
	# Clean map
	# Place autotiles
	# Populate map
	# Spawn player
	world_tilemap.force_update(0)

func generate_map(map_generator, tilemap: TileMap, size: Vector2 = Vector2(160, 90)):
	map_generator.generate_map(tilemap, size)
	tilemap.force_update(0)


func clean_map(tilemap: TileMap, size: Vector2):
	for x in size.x:
		for y in size.y:
			var pos: Vector2i = Vector2i(x, y)
			var cell_terrain = tilemap.get_cell_tile_data(0, Vector2i(x, y)).get_terrain_offset()
			var cellcount: int = 0
			for offset in tilemap.get_surrounding_tiles(pos):
				if tilemap.get_cell_tile_data(0, offset).get_terrain_offset() == cell_terrain:
					cellcount += 1
			if cellcount < 3:
				if tilemap.get_cell_tile_data(0, pos).get_terrain_offset() == TILES.WHITE:
					tilemap.set_cell(0, pos, 1, TILES.BLACK)
				else:
					tilemap.set_cell(0, pos, 1, TILES.WHITE)
	tilemap.force_update(0)




#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.pause()
