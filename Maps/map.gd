extends Node2D


@onready var pause_menu = %"UI_Pause Menu"
@onready var world_tilemap: TileMap = %TileMap


var noise_map_gen: NoiseWorldGenerator = NoiseWorldGenerator.new()
var walker_map_gen: WalkerWorldGenerator = WalkerWorldGenerator.new()

#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func _ready() -> void:
	# Generate map
	generate_map(noise_map_gen, world_tilemap)

	# Clean map
	# Place autotiles
	# Populate map
	# Spawn player

func generate_map(map_generator, tilemap: TileMap):
	map_generator.generate_map(tilemap)


#-------------------------------------------------------------------------------
# UI Interaction
#-------------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_menu.pause()
