extends PartyManager

class_name PlayerPartyManager

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func spawn_actors() -> void:
	if spawn_actors_manually:
		var spawn_pos: Vector2 = get_tree().get_node("PlayerSpawn").get_child(0).get_global_position()
		spawn(spawn_pos, actor_amount)




#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func move_party_target(delta: float):
	var vel: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.5).normalized() * party_speed
	pb.party_target_pos += vel * delta
	pb.party_target_vel = vel


