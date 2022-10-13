extends Node

class_name MapGeneratorManager

var map_data: MapDataObject
var map_generator

func _init(new_map_data) -> void:
	map_data = new_map_data
	map_generator = map_data.generation_method.new(map_data)
	run_mapgenerator_functions()
	map_data.global_tilemap.force_update(0)

func run_mapgenerator_functions():
	map_generator.generate_map_blueprint()
	map_generator.generate_map_borders()
	map_generator.clean_map()
	map_generator.populate_map_blueprint()


