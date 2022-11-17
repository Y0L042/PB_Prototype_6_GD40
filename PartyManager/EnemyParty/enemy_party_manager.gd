extends PartyManager

class_name EnemyPartyManager

var vec

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	vec = choose_initial_direction()

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func party_process(delta: float):
	if pb.active_actors.is_empty():
		party_defeated()
		set_physics_process(false)
	move_party_target(move_target(delta))


func choose_initial_direction():
	var range: int = 10
	var px: int = randi_range(-range, range)
	var py: int = randi_range(-range, range)
	var vec = Vector2(px, py).normalized()
	return vec


func move_target(delta: float):
	var vel: Vector2 = vec * party_speed
	var party_target_pos = pb.party_target_pos + (vel * delta)
	return party_target_pos


func move_party_target(position: Vector2):
	pb.party_target_pos = position
	pb.party_target_vel = pb.party_pos.direction_to(pb.party_target_pos) * party_speed


func party_wander():
	pass
#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func party_defeated():
	if !pb.all_actors.is_empty() and pb.active_actors.is_empty():
		pb.main_game.player_party_manager.add_defeated_party_actors(pb.all_actors)
