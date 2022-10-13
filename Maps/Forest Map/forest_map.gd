extends Node2D

@onready var world_tilemap: TileMap = %TileMap
@export var tilemap_size: Vector2 = Vector2(160, 90)




#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	var new_map_data := MapDataObject.new()
	new_map_data.generation_method = SceneLib.map_generator.noise_map
	new_map_data.global_tilemap = world_tilemap
	new_map_data.global_map_size = tilemap_size

	generate_blueprint_map(new_map_data)


#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func generate_blueprint_map(new_map_data):
	var mapgenman := MapGeneratorManager.new(new_map_data)


func populate_blueprint_map():
	pass
