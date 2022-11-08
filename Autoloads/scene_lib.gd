extends Node

#-------------------------------------------------------------------------------
# Scenes
#-------------------------------------------------------------------------------
var ENEMY_PARTY: PackedScene = load("res://PartyManager/EnemyParty/enemy_party.tscn")
var PLAYER_PARTY: PackedScene = load("res://PartyManager/PlayerParty/player_party.tscn")

var KNIGHT: PackedScene = load("res://Actor/Knight/knight.tscn")



#-------------------------------------------------------------------------------
# Maps
#-------------------------------------------------------------------------------
var leveled_list_maps: Array = [
	load("res://Maps/Starting Map/level_000.tscn"),
	load("res://Maps/Level 1/Level 1.1/level_101.tscn"),
]




const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

var STARTING_MAP: PackedScene =  load("res://Maps/Starting Map/starting_map.tscn")
var FOREST_MAP: PackedScene = load("res://Maps/Forest Map/forest_map.tscn")
var DUNGEON_MAP: PackedScene = load("res://Maps/Dungeon Map/dungeon_map.tscn")
var CASTLE_MAP: PackedScene = load("res://Maps/Castle Map/castle_map.tscn")
var TINYKEEP_WORLDGEN: PackedScene = load("res://Procedural Map Worlds/TinyKeep World/tiny_keep_world.tscn")

var map_generator: Dictionary = {
	"noise_map": NoiseWorldGenerator,
	"walker_map": WalkerWorldGenerator,
	"tinykeep_map": TinyKeepWorldGenerator
}

var TINYKEEP_ROOM: PackedScene = load("res://Procedural Map Worlds/TinyKeep World/room.tscn")



#-------------------------------------------------------------------------------
# UI
#-------------------------------------------------------------------------------
var MAIN_MENU: PackedScene = load("res://UI/ui_main_menu.tscn")
var PAUSE_MENU: PackedScene = load("res://UI/ui_pause_menu.tscn")


#-------------------------------------------------------------------------------
# Scene Tools
#-------------------------------------------------------------------------------
func spawn_child(child: PackedScene, parent):
	var child_instance = child.instantiate()
	parent.add_child(child_instance)
	child_instance.set_global_position(Vector2.ZERO)
	return child_instance


func change_scene():
	pass
