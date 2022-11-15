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



# Wasteland
var WORLD_WASTELAND := WorldWasteland.new()




# Dictionary of Worlds , Place last, otherwise vars like WRLD_WASTELAND would still be null
var WORLD = {
	"WASTELAND" : WORLD_WASTELAND,
}
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
func spawn_child(child: PackedScene, parent, new_global_position: Vector2 = Vector2.ZERO, variant: Variant = null):
	var child_instance
	if variant != null:
		child_instance = child.instantiate(variant)
	else:
		child_instance = child.instantiate()
	parent.add_child(child_instance)
	child_instance.set_global_position(Vector2.ZERO)
	return child_instance


func return_random_scene(new_array: Array):
	var rand_index = randi_range(0, new_array.size() - 1)
	return new_array[rand_index]


func change_scene():
	pass

var CONTINUE_GAME: bool
func save_game():
	print("TBI - Save Game")
func load_game():
	print("TBI = Load Game")






















#-------------------------------------------------------------------------------
# Obsolete
#-------------------------------------------------------------------------------

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

