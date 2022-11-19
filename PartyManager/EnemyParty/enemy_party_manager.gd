extends PartyManager

class_name EnemyPartyManager

var vec

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	pb.party_max_speed = 1 * GlobalSettings.UNIT

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func party_process(delta: float):
	if pb.active_actors.is_empty():
		party_defeated()
		set_physics_process(false)

	move(delta)
#	move_party_target(move_target(delta))




func move(delta: float):
	var party_prev_pos = pb.party_target_pos
	pb.party_target_pos = wander(delta)
	pb.party_target_vel = pb.party_target_pos - party_prev_pos
	pb.party_formation.set_grid_center_position(pb.party_formation.vector_array, pb.party_target_pos)



func wander(delta: float):
	var pos: Vector2
	if pb.party_target_vel == Vector2.ZERO:
		pb.party_target_vel = Vector2(1,1)
	var vel = SBL.wander(pb.party_target_pos, pb.party_target_vel) * party_speed * delta / 2
	if true:
		pos = pb.party_target_pos + vel
	pos = collision_avoidance_adjuster(pb.party_pos, pos)
	return pos


func collision_avoidance_adjuster(self_pos, target_pos):
	var new_dir: Vector2
	var offset: float = deg_to_rad(36)
	var isRaycastIntersected: bool = !do_line_raycast(self_pos, target_pos, 0x1).is_empty()
	while isRaycastIntersected:
		new_dir = (target_pos - self_pos).rotated(offset)
		target_pos = new_dir + self_pos
		isRaycastIntersected = !do_line_raycast(self_pos, target_pos, 0x1).is_empty()
		if isRaycastIntersected:
			new_dir = (target_pos - self_pos).rotated(-offset)
			target_pos = new_dir + self_pos
			isRaycastIntersected = !do_line_raycast(self_pos, target_pos, 0x1).is_empty()
			if isRaycastIntersected:
				offset *= 2
	return target_pos




func do_line_raycast(from: Vector2, to: Vector2, col_mask = 0xFFFFFFFF):
	var ray_query := PhysicsRayQueryParameters2D.create(from, to, col_mask)
	var raycast = get_world_2d().direct_space_state.intersect_ray(ray_query)
	return raycast














#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func party_defeated():
	if !pb.all_actors.is_empty() and pb.active_actors.is_empty():
		pb.main_game.player_party_manager.add_defeated_party_actors(pb.all_actors)
