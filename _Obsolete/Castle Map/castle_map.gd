extends Node2D

@onready var world_tilemap: TileMap = %CastleTileMap
@export var tile_size: int = 64
@export var num_rooms: int = 50
@export var min_size: int = 6
@export var max_size: int = 15
@export var hspread: int = 400
@export var cull: float = 0.75






#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	var new_map_data := MapDataObject.new()
	new_map_data.generation_method = SceneLib.map_generator.tinykeep_map
	new_map_data.global_tilemap = world_tilemap
	new_map_data.tinykeep_tile_size = tile_size
	new_map_data.tinykeep_num_rooms = num_rooms
	new_map_data.tinykeep_min_size = min_size
	new_map_data.tinykeep_max_size = max_size
	new_map_data.tinykeep_hspread = hspread
	new_map_data.tinykeep_cull = cull


	generate_blueprint_map(new_map_data)

#	populate_blueprint_map(new_map_data)


#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func generate_blueprint_map(new_map_data):
	var tinykeep_instance = SceneLib.TINYKEEP_WORLDGEN.instantiate()
	self.add_child(tinykeep_instance)
	tinykeep_instance.set_global_position(Vector2.ZERO)
	tinykeep_instance.tinykeep_setup(new_map_data)
	tinykeep_instance.generate_map_blueprint()
	await tinykeep_instance.gen_complete
	populate_blueprint_map(new_map_data)


func populate_blueprint_map(new_map_data):
	var decorator := TileMapDecorator.new(new_map_data)
	decorator.tilemapdecorator_ready()

