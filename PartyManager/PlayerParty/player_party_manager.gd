extends PartyManager

class_name PlayerPartyManager

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func move_party_target(delta: float):
	var vel: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.5).normalized() * party_speed
	pb.party_target_pos += vel * delta
	pb.party_target_vel = vel

func party_process(delta: float):
	if pb.active_actors.is_empty():
		allActorsDead.emit(self)

		#temp


