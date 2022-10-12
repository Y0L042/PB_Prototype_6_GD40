extends Node2D

class_name WalkerWorldGenerator

@onready var map: TileMap = %TileMap

var noise_map_gen: NoiseWorldGenerator
var walker_map_gen: WalkerWorldGenerator

#-------------------------------------------------------------------------------
# Generating Map
#-------------------------------------------------------------------------------
func _ready() -> void:
	pass
	# Generate map
	# Clean map
	# Place autotiles
	# Populate map
	# Spawn player

func generate_map(map_generator):
	map_generator = map_generator.new()
