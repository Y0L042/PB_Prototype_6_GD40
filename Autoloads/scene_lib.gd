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
var OUTDOOR_WORLD: PackedScene = load("res://Maps/map.tscn")

#-------------------------------------------------------------------------------
# Maps
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
