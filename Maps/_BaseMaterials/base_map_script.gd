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
	%East.get_global_position(),
	%South.get_global_position(),
	%West.get_global_position(),
	%North.get_global_position()
]



