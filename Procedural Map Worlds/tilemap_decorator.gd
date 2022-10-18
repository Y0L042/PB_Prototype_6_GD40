extends Node

class_name TileMapDecorator

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var tilemap: TileMap

#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _init(new_map_data: MapDataObject) -> void:
	tilemap = new_map_data.global_tilemap



func tilemapdecorator_ready():
	autotile_paving(tilemap)


func autotile_paving(new_tilemap: TileMap = tilemap):
	var bp_tiles: Array = new_tilemap.get_used_cells(0)
	for tilepos in bp_tiles:
		if new_tilemap.get_cell_atlas_coords(0, tilepos) == SceneLib.TILES.WHITE:
			new_tilemap.set_cell(1, tilepos, 1, SceneLib.TILES.BLACK)
		if new_tilemap.get_cell_atlas_coords(0, tilepos) == SceneLib.TILES.BLACK:
			new_tilemap.set_cell(1, tilepos, 1, SceneLib.TILES.WHITE)
