extends Node2D

class_name BaseMapScript

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
signal ConditionSignal

@onready var player_spawn_pos: Vector2 = %PlayerSpawn.get_global_position()
@onready var enemy_spawns := %EnemySpawns
@onready var item_spawns := %ItemSpawns
@onready var condition := %Condition

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

