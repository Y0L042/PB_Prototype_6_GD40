extends PartyManager

class_name PlayerPartyManager


var necromance_queue: Array
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func move_target(delta: float):
	var vel: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.5).normalized() * party_speed
	var party_target_pos = pb.party_target_pos + (vel * delta)
#	if party_target_pos.distance_to(pb.party_pos) > 1000:
#		return pb.party_target_pos
	return party_target_pos


func party_process(delta: float):
	if pb.active_actors.is_empty():
		allActorsDead.emit(self)
	move_party_target(move_target(delta))
	if !necromance_queue.is_empty():
		necromance()


#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func add_defeated_party_actors(new_party_actors):
	necromance_queue.append_array(new_party_actors)

func necromance():
	for actor in necromance_queue:
		spawn_actor(actor.self_scene, Tools.random_offset(pb.party_pos, GlobalSettings.UNIT * 5))
