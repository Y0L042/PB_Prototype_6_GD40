extends Actor

class_name KnightActor


#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
enum states {
	PASSIVE,
	AGGRESSIVE,
	HURT,
	DEAD,
}


#-------------------------------------------------------------------------------
# State Machine
#-------------------------------------------------------------------------------
func change_state(NEW_STATE: int):
	current_state = NEW_STATE

func state_process():
	if current_state == states.PASSIVE:
		state_process_passive()
	if current_state == states.AGGRESSIVE:
		state_process_aggressive()
	if current_state == states.HURT:
		state_process_hurt()
	if current_state == states.DEAD:
		state_process_dead()


#-------------------------------------------------------------------------------
# State Functions
#-------------------------------------------------------------------------------
func state_process_passive():
	if pb.party_target_pos == Vector2.ZERO:
		return

	var seek_arrive_weight: float = 1.0
	var stopdist: float = 15
	var dropoff: float = 25

	var target_dist = get_global_position().distance_to(pb.party_target_pos)
	var collidingAgainstPersonNextToTarget: bool = false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i).get_collider()
		if collision.is_in_group(pb.party_group):
			collidingAgainstPersonNextToTarget = collision.arrivedAtTarget or collidingAgainstPersonNextToTarget

	var isColliding: bool = get_slide_collision_count() > 0
	var targetNotMoving: bool = pb.party_target_vel.length() <= 5
	var withinRadius: bool = target_dist <= pb.active_actors_count*10
	var nextToTarget: bool = target_dist <= 25
	arrivedAtTarget = nextToTarget or (targetNotMoving and withinRadius and isColliding and collidingAgainstPersonNextToTarget)

	if !arrivedAtTarget:
		var seek_target = SBL.log_seek_arrive(get_global_position(), pb.party_target_pos, velocity, seek_arrive_weight, true, stopdist, dropoff)
		steering_vector_array.append(seek_target)



func state_process_aggressive():
	pass



func state_process_hurt():
	pass



func state_process_dead():
	pass


