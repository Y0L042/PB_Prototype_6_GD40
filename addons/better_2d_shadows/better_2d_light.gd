extends Node2D

class_name BetterLight2D





#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@export var LightGroupID: String = "BetterLight2D#137"
@export var ShadowGroupID: String = "BetterShadow2D#137"
@export var light_strength: float

func _init():
	add_to_group(LightGroupID)

func _physics_process(delta):
	get_tree().call_group("ShadowGroupID", "cast_shadow")
