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
	if true: # TODO: if inside map
		pos = pb.party_target_pos + vel

	pos = collision_avoidance_adjuster(pb.party_pos, pos)

#	var target_pos: Vector2 = pos
#	var self_pos: Vector2 = self.pb.party_pos
#	var new_dir: Vector2
#	var offset: float = deg_to_rad(36)
#	var isRaycastIntersected: bool = !do_line_raycast(self_pos, target_pos, 0x1).is_empty()
#	while isRaycastIntersected:
#		new_dir = (target_pos - self_pos).rotated(offset)
#		target_pos = new_dir + self_pos
#		isRaycastIntersected = !do_line_raycast(self_pos, target_pos, 0x1).is_empty()
#		if isRaycastIntersected:
#			new_dir = (target_pos - self_pos).rotated(-offset)
#			target_pos = new_dir + self_pos
#			isRaycastIntersected = !do_line_raycast(self_pos, target_pos, 0x1).is_empty()
#			if isRaycastIntersected:
#				offset *= 2

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

#func collision_avoidance(target, self_pos, delta):
#	var RAY_LENGTH: int = GlobalSettings.UNIT * 10
#	var collision_mask: int = 0x1
#	# Calculate direction to target
#	var target_dir = pb.party_pos.direction_to(target)
#
#	# Calculate new position after moving in player direction
#	var new_pos = target
#
#	# do raycast towards target
#	# if it intersects, do one either side, expanding until it finds a clear path
#	var raycast_dir: Vector2 = target_dir
#	var raycast_rotation_offset = deg_to_rad(36)
#	var offset_raycast_dir: Vector2 = raycast_dir
#	var isRaycastIntersected = do_line_raycast(self.pb.party_pos, raycast_dir * RAY_LENGTH, collision_mask).is_empty()
#	while isRaycastIntersected:
#		offset_raycast_dir = raycast_dir.rotated(raycast_rotation_offset)
#		isRaycastIntersected = do_line_raycast(self.pb.party_pos, self.pb.party_pos + offset_raycast_dir * RAY_LENGTH, collision_mask).is_empty()
#		if isRaycastIntersected:
#			offset_raycast_dir = raycast_dir.rotated(-raycast_rotation_offset)
#			isRaycastIntersected = do_line_raycast(self.pb.party_pos, self.pb.party_pos + offset_raycast_dir * RAY_LENGTH, collision_mask).is_empty()
#			if isRaycastIntersected:
#				raycast_rotation_offset *= 2
#			else:
#				break
#		else:
#			break
#	var new_target_pos: Vector2 = pb.party_pos + offset_raycast_dir * party_speed # * delta / 2
#	return new_target_pos


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
