extends Marker2D

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
var group: String
var damage: float = 1.0
var attack_range: int = 35

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
@onready var hitbox: Area2D = %Hitbox




#-------------------------------------------------------------------------------
# Lambda Functions
#-------------------------------------------------------------------------------

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
# Signals
#-------------------------------------------------------------------------------
func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
		if !body.pb.party_group == group:
			body.take_damage(damage)
