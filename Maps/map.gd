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

const isurrounding_tiles: PackedVector2Array = [
	Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
	Vector2i(-1, 0),                  Vector2i(1, 0),
	Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1),
]


#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	create_map(map_generators.noise_map, Vector2(160, 90))
#	create_map(map_generators.walker_map, Vector2(160, 90))





#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func create_map(map_generator, size: Vector2 = Vector2(160, 90)):
	map_generator.generate_map(world_tilemap, size)
	map_generator.clean_map(world_tilemap, size)
	# Place autotiles
	# Populate map
	# Spawn player
	world_tilemap.force_update(0)




#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.pause()
