extends Marker2D

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
var group: String
@export var damage: float = 1.0
@export var sight_range: float = 5 * GlobalSettings.UNIT : set = set_sight_range
@export var effective_range_max: float = 1 * GlobalSettings.UNIT : set = set_effective_range_max
@export var effective_range_min: float = 0 * GlobalSettings.UNIT : set = set_effective_range_min
@export var trigger_range: float = 1 * GlobalSettings.UNIT : set = set_trigger_range

var enemy_array: Array = []
var enemy
#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var hitbox: Area2D = %Hitbox
@onready var weapon_anim_player: AnimationPlayer = $SwordAnimationPlayer
@onready var weapon_anim_tree: AnimationTree = %SwordAnimationTree
@onready var weapon_anim_tree_mode = weapon_anim_tree["parameters/playback"]


#-------------------------------------------------------------------------------
# Conditions
#-------------------------------------------------------------------------------
var is_enemy_in_sight_range: bool = false
var is_enemy_in_trigger_range: bool = false
var is_enemy_in_effective_range: bool = false


#-------------------------------------------------------------------------------
# SetGets
#-------------------------------------------------------------------------------
func set_sight_range(new_sight_range):
	sight_range = new_sight_range * GlobalSettings.UNIT


func set_effective_range_max(new_effective_range_max):
	effective_range_max = new_effective_range_max * GlobalSettings.UNIT

func set_effective_range_min(new_effective_range_min):
	effective_range_min = new_effective_range_min * GlobalSettings.UNIT

func set_trigger_range(new_trigger_range):
	trigger_range = new_trigger_range * GlobalSettings.UNIT



#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	weapon_anim_tree_mode.start("Idle")

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
#	check_conditions()
	pass

#func check_conditions():
#	if !enemy_array.is_empty():
#		enemy = enemy_array[0]
#	else:
#		enemy = null
#	for _enemy in enemy_array:
#		if get_global_position().distance_squared_to(_enemy.get_global_position()) < \
#		get_global_position().distance_squared_to(enemy.get_global_position()):
#			enemy = _enemy
#	if enemy != null:
#		var enemy_dist_sqrd: float = get_global_position().distance_squared_to(enemy.get_global_position())
#		if enemy_dist_sqrd <= trigger_range*trigger_range:
#			is_enemy_in_trigger_range = true
#		else:
#			is_enemy_in_trigger_range = false
#
#		if enemy_dist_sqrd <= effective_range_max*effective_range_max and enemy_dist_sqrd >= effective_range_min*effective_range_min:
#			is_enemy_in_effective_range = true
#		else:
#			is_enemy_in_effective_range = false
#
#		if enemy_dist_sqrd <= sight_range*sight_range:
#			is_enemy_in_sight_range = true
#		else:
#			is_enemy_in_sight_range = false


#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func attack():
	weapon_anim_tree_mode.travel("Attack")

#-------------------------------------------------------------------------------
# Signals
#-------------------------------------------------------------------------------
func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
		if body.pb.party_group != group:
			body.take_damage(damage)



func _on_weapon_area_body_entered(body: Node2D) -> void:
	if body.pb.party_group != group:
		enemy_array.append(body)


func _on_weapon_area_body_exited(body: Node2D) -> void:
	enemy_array.erase(body)
