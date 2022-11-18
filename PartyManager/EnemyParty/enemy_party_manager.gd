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

	move(delta)
#	move_party_target(move_target(delta))




func move(delta: float):
	var pb.party_target_pos = wander(delta)


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


func wander(delta: float):
	if pb.party_target_vel == Vector2.ZERO:
		pb.party_target_vel = Vector2(1,1)
	var vel = SBL.wander(pb.party_target_pos, pb.party_target_vel) * party_speed * delta / 2
	if true: # TODO: if inside map
		pb.party_target_vel = vel
		pb.party_target_pos += vel
	move_formation(collision_avoidance(pb.party_target_pos,delta), 0)
#	move_formation(pb.party_target_pos, 0)


func collision_avoidance(target, delta):
	var RAY_LENGTH: int = 150
	var collision_mask: int = 0x1
	# Calculate direction to target
	var target_dir = pb.party_pos.direction_to(target)

	# Calculate new position after moving in player direction
	var new_pos = pb.party_target_pos + target_dir * pb.party_max_speed * delta

	# do raycast towards target
	# if it intersects, do one either side, expanding until it finds a clear path
	var raycast_dir: Vector2 = new_pos.normalized()
	var raycast_rotation_offset = deg_to_rad(36)
	var offset_raycast_dir: Vector2 = raycast_dir
	var isRaycastIntersected = do_line_raycast(self.pb.party_pos, raycast_dir * RAY_LENGTH, collision_mask).is_empty()
	while isRaycastIntersected:
		offset_raycast_dir = raycast_dir.rotated(raycast_rotation_offset)
		isRaycastIntersected = do_line_raycast(self.pb.party_pos, self.pb.party_pos + offset_raycast_dir * RAY_LENGTH, collision_mask).is_empty()
		if isRaycastIntersected:
			offset_raycast_dir = raycast_dir.rotated(-raycast_rotation_offset)
			isRaycastIntersected = do_line_raycast(self.pb.party_pos, self.pb.party_pos + offset_raycast_dir * RAY_LENGTH, collision_mask).is_empty()
			if isRaycastIntersected:
				raycast_rotation_offset *= 2
			else:
				break
		else:
			break
	var new_target_pos: Vector2 = pb.party_pos + offset_raycast_dir * pb.party_max_speed * delta
	return new_target_pos


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
