extends Node2D

class_name BaseMapScript

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
signal ConditionSignal

@export var map_meta_data: Resource

@onready var player_spawn := %PlayerSpawn
@onready var enemy_spawns := %EnemySpawns
@onready var item_spawns := %ItemSpawns
@onready var condition := %Conditions

@onready var docks: Array = [
	%East,
	%South,
	%West,
	%North
]

var level_meta_data: LevelMetaData
#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var level_name: String
@export var level_rating: int

#-------------------------------------------------------------------------------
# Custom Classes
#-------------------------------------------------------------------------------
class LevelMetaData:
	var level_name: String
	var level_rating: int
	var level_ref := self

	func _init(new_level_name: String, new_level_rating: int):
		level_name = new_level_name
		level_rating = new_level_rating

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init() -> void:
	level_meta_data = LevelMetaData.new(level_name, level_rating)

func spawn_player_party(player_party_manager, player_starting_actors: int):
	player_party_manager.spawn(player_spawn.get_global_position(), player_starting_actors)

#-------------------------------------------------------------------------------
# Map Functions
#-------------------------------------------------------------------------------
func erase_disabled_docks():
	var erase_docks: Array
	for dock in docks:
		if dock and !dock.visible:
			dock.queue_free()
			dock = null


func get_opposite_dock(current_dock):
	if current_dock == %East:
		return %West
	if current_dock == %South:
		return %North
	if current_dock == %West:
		return %East
	if current_dock == %North:
		return %South
	return -1
