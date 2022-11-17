extends Node



#-------------------------------------------------------------------------------
# Steering Pipeline
#-------------------------------------------------------------------------------
func steering_vectors_processor(steering_vector_array: PackedVector2Array, max_speed: int): # adds all forces in steering vector array for final force
	var final_velocity: Vector2 = Vector2.ZERO
	for vector in steering_vector_array:
		final_velocity += vector
	steering_vector_array.clear()
	final_velocity *= max_speed
	final_velocity.limit_length(max_speed) #clamp(final_velocity, Vector2(-max_speed, -max_speed), Vector2(max_speed, max_speed))
	return final_velocity



#-------------------------------------------------------------------------------
# Steering Functions
#-------------------------------------------------------------------------------
func log_seek_arrive(current_pos: Vector2, seek_target: Vector2, current_vel: Vector2, weight: float = 1.0, arrive: bool = false, stopdist: float = 0.0, dropoff: float = 1.0):
	if arrive:
		var dist: float = abs(current_pos.distance_to(seek_target))
		dist = max(dist - stopdist, 0)
		weight = (sqrt(dist) * dropoff)
		weight = clamp(weight, 0, 1)
	var vel: Vector2 = current_pos.direction_to(seek_target) * weight
	return vel # normalized, weighted



func wander(current_pos: Vector2, current_vel: Vector2 = Vector2.ZERO, weight: float = 1.0):
	var wander_offset: float = 750.0
	var wander_radius: float = 50000.0
	var wander_theta_max_offset: float = 15
	var wander_pos: Vector2 = current_pos + (current_vel.normalized() * wander_offset)
	var theta: float = 0 # zero ref is E, Clockwise
	theta += randf_range(-wander_theta_max_offset, wander_theta_max_offset)
	theta = deg_to_rad(theta) + current_vel.angle() # makes theta relative to vehicle direction
	var x: float = wander_radius * cos(theta)
	var y: float = wander_radius * sin(theta)
	var wander_target: Vector2 = wander_pos + Vector2(x, y)
	var vel: Vector2 = seek(current_pos, wander_target, weight)
	return vel # normalized, weighted



func collision_avoidance(current_pos: Vector2, current_vel: Vector2, collision_pos: Vector2, weight: float = 1.0):
	var dist_vec: Vector2 = current_pos.direction_to(collision_pos)
	var dot: float = abs(current_vel.normalized().dot(dist_vec))
	weight =  dot * weight
	var steer_vec: Vector2 = abs(current_vel.dot(dist_vec)) * current_vel.normalized() + current_pos - collision_pos
#	var vel: Vector2 = -1 * steer_vec.normalized() * weight
	var vel: Vector2 = -dist_vec * weight
	return vel



func seek(current_pos: Vector2, seek_target: Vector2, weight: float = 1.0):
	var vel: Vector2 = current_pos.direction_to(seek_target) * weight
	return vel # normalized, weighted



func flee(current_pos: Vector2, current_vel: Vector2, flee_target: Vector2, weight: float = 1.0):
	var vel: Vector2 = log_seek_arrive(current_pos, flee_target, current_vel, weight) * -1
	return vel # normalized, weighted


func arrive(current_pos: Vector2, seek_target: Vector2, arrive_distance: float,  weight: float = 1.0):
	var dist_squared: float =  current_pos.distance_squared_to(seek_target)
	var dir_vec: Vector2 = current_pos.direction_to(seek_target)
	if dist_squared > arrive_distance * arrive_distance:
		return seek(current_pos, seek_target, weight)
	else:
		var vel: Vector2 = dir_vec * current_pos.distance_squared_to(seek_target) / (arrive_distance*arrive_distance) * weight
		return vel # not completely normalized, weighted


func project_collision_raycasts(current_pos: Vector2, current_vel: Vector2, space_state: PhysicsDirectSpaceState2D, fov: float, ray_distance: float, ray_count: int):
	var rc_results_dict_array: Array = []
	for ray in ray_count + 1:
		var rc_query := PhysicsRayQueryParameters2D.new()
		rc_query.set_exclude([self.get_rid()])
		rc_query.set_from(current_pos)

		var theta: float = 0 # zero ref is E, Clockwise
		theta = theta - (0.5*fov) + (fov/ray_count)*ray
		theta = deg_to_rad(theta) + current_vel.angle() # makes theta relative to vehicle direction
		var x: float = ray_distance * cos(theta)
		var y: float = ray_distance * sin(theta)
		var ray_end: Vector2 = current_pos + Vector2(x, y)

		rc_query.set_to(ray_end)
		rc_results_dict_array.append(space_state.intersect_ray(rc_query))
	return rc_results_dict_array
