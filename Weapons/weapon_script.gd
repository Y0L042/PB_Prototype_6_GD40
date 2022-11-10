extends Marker2D

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
var group: String
@export var damage: float = 1.0
@export var attack_range: int = 1 * GlobalSettings.UNIT : set = set_attack_range

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var hitbox: Area2D = %Hitbox




#-------------------------------------------------------------------------------
# SetGets
#-------------------------------------------------------------------------------
func set_attack_range(new_attack_range):
	attack_range = new_attack_range * GlobalSettings.UNIT


#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var weapon_anim_player: AnimationPlayer = $SwordAnimationPlayer
@onready var weapon_anim_tree: AnimationTree = %SwordAnimationTree
@onready var weapon_anim_tree_mode = weapon_anim_tree["parameters/playback"]

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

