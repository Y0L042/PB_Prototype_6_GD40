extends Node2D

@onready var world_tilemap: TileMap = %DungeonTileMap
@export var tilemap_size: Vector2 = Vector2(160, 90)

@export var walker_total_steps: int = 500
@export var walker_corridor_width: int = 3
@export var walker_room_size_range: Vector2 = Vector2(5, 12)


#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	var new_map_data := MapDataObject.new()
	new_map_data.generation_method = SceneLib.map_generator.walker_map
	new_map_data.global_tilemap = world_tilemap
	new_map_data.global_map_size = tilemap_size
	new_map_data.walker_total_steps = walker_total_steps
	new_map_data.walker_corridor_width = walker_corridor_width
	new_map_data.walker_room_size_range = walker_room_size_range

	generate_blueprint_map(new_map_data)


#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func generate_blueprint_map(new_map_data):
	var mapgenman := MapGeneratorManager.new(new_map_data)


func populate_blueprint_map():
	pass
