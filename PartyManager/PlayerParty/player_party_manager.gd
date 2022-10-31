extends PartyManager

class_name PlayerPartyManager

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	if spawn_actors_manually:
		var spawn_pos: Vector2 = get_tree().get_root().get_node("PlayerSpawn").get_child(0).get_global_position()
		set_party_blackboard(actor_amount, spawn_pos)
		spawn_party_actors()



#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func move_party_target(delta: float):
	var vel: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.5).normalized() * party_speed
	pb.party_target_pos += vel * delta
	pb.party_target_vel = vel


