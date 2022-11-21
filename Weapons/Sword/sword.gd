extends Marker2D

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
var group: String
@export var damage: float = 1.0
@export var sight_range: float = 5 * GlobalSettings.UNIT : set = set_sight_range
@export var effective_range: float = 1 * GlobalSettings.UNIT : set = set_effective_range
@export var trigger_range: float = 1 * GlobalSettings.UNIT : set = set_trigger_range

var enemy_array: Array = []
#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var hitbox: Area2D = %Hitbox
@onready var weapon_anim_player: AnimationPlayer = $SwordAnimationPlayer
@onready var weapon_anim_tree: AnimationTree = %SwordAnimationTree
@onready var weapon_anim_tree_mode = weapon_anim_tree["parameters/playback"]
@onready var weapon_area: Area2D = %WeaponArea


#-------------------------------------------------------------------------------
# SetGets
#-------------------------------------------------------------------------------
func set_sight_range(new_sight_range):
	sight_range = new_sight_range * GlobalSettings.UNIT
	weapon_area.shape.set_scale(sight_range)

func set_effective_range(new_effective_range):
	effective_range = new_effective_range * GlobalSettings.UNIT

func set_trigger_range(new_trigger_range):
	trigger_range = new_trigger_range * GlobalSettings.UNIT



#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	weapon_anim_tree_mode.start("Idle")

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
