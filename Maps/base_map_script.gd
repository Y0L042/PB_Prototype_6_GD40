extends Node2D

class_name BaseMapScript

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
signal ConditionSignal

@onready var player_spawn_pos: Vector2 = %PlayerSpawn.get_global_position()
