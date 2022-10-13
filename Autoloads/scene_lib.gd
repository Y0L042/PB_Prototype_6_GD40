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
#var MapDataObject = load("res://Maps/mapdata_object.gd")

var FOREST_MAP: PackedScene = load("res://Maps/Forest Map/forest_map.tscn")
var DUNGEON_MAP: PackedScene = load("res://Maps/Dungeon Map/dungeon_map.tscn")

var map_generator: Dictionary = {
	"noise_map": NoiseWorldGenerator,
	"walker_map": WalkerWorldGenerator,
}

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
