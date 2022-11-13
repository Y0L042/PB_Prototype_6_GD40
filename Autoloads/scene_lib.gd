extends Node

#-------------------------------------------------------------------------------
# Actor Scenes
#-------------------------------------------------------------------------------
var ENEMY_PARTY: PackedScene = load("res://PartyManager/EnemyParty/enemy_party.tscn")
var PLAYER_PARTY: PackedScene = load("res://PartyManager/PlayerParty/player_party.tscn")
var PARTY_MATERIAL: Resource = load("res://PartyManager/party_shader_material.tres")

# Make it a list or dictionary or something
var KNIGHT: PackedScene = load("res://Actor/Knight/knight.tscn")


#-------------------------------------------------------------------------------
# Weapons
#-------------------------------------------------------------------------------
# Make it a list or dictionary or something
var WPN_SWORD: PackedScene = load("res://Weapons/Sword/sword.tscn")

#-------------------------------------------------------------------------------
# Maps
#-------------------------------------------------------------------------------
# Controllers
var MAIN_MENU_c: PackedScene = load("res://Maps/Main Menu/main_menu.tscn")
var MAIN_GAME_c: PackedScene = load("res://Maps/Main Game/main_game.tscn")

# Dictionary of Worlds
var WORLD = {
	"WASTELAND" : WRLD_WASTELAND,
}

# Wasteland World Dictionary
var WRLD_WASTELAND = {
	"LVL_ORDER" : [
		"STD_BATTLE_MAPS",
		"STD_BATTLE_MAPS",
		"STD_BATTLE_MAPS",
	],

	"STD_BATTLE_MAPS" : [
		load("res://Maps/World_Desert/Standard Battle Maps/Variant 1/std_battle_map_variant_1.tscn"),
	]
}


const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

#var STARTING_MAP: PackedScene =  load("res://Maps/Starting Map/starting_map.tscn")
#var FOREST_MAP: PackedScene = load("res://Maps/Forest Map/forest_map.tscn")
#var DUNGEON_MAP: PackedScene = load("res://Maps/Dungeon Map/dungeon_map.tscn")
#var CASTLE_MAP: PackedScene = load("res://Maps/Castle Map/castle_map.tscn")
#var TINYKEEP_WORLDGEN: PackedScene = load("res://Procedural Map Worlds/TinyKeep World/tiny_keep_world.tscn")

var map_generator: Dictionary = {
	"noise_map": NoiseWorldGenerator,
	"walker_map": WalkerWorldGenerator,
	"tinykeep_map": TinyKeepWorldGenerator
}

var TINYKEEP_ROOM: PackedScene = load("res://Procedural Map Worlds/TinyKeep World/room.tscn")



#-------------------------------------------------------------------------------
# UI
#-------------------------------------------------------------------------------
var UI_MAIN_MENU: PackedScene = load("res://UI/ui_main_menu.tscn")
var UI_PAUSE_MENU: PackedScene = load("res://UI/ui_pause_menu.tscn")
var UI_ENDOFLEVELCHOICE: PackedScene = load("res://UI/ui_end_of_level_choice.tscn")
var UI_GAME_END: PackedScene = load("res://UI/ui_game_end.tscn")

#-------------------------------------------------------------------------------
# Scene Tools
#-------------------------------------------------------------------------------
func spawn_child(child: PackedScene, parent, new_global_position: Vector2 = Vector2.ZERO):
	var child_instance = child.instantiate()
	parent.add_child(child_instance)
	child_instance.set_global_position(new_global_position)
	return child_instance


func change_scene():
	pass

func save_game():
	print("TBI - Save Game")
func load_game():
	print("TBI = Load Game")
