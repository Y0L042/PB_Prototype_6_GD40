extends Actor

class_name KnightActor

var self_scene := SceneLib.KNIGHT

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

func player_state_process():
	if current_state == states.PASSIVE:
		state_process_passive()
	if current_state == states.AGGRESSIVE:
		state_process_aggressive()
	if current_state == states.HURT:
		state_process_hurt()
	if current_state == states.DEAD:
		state_process_dead()

func enemy_state_process():
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
	var stopdist: float = GlobalSettings.UNIT * 0.9
	var target_dist = get_global_position().distance_to(pb.party_target_pos)
	var collidingAgainstPersonNextToTarget: bool = false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i).get_collider()
		if collision and collision.is_in_group(pb.party_group):
			collidingAgainstPersonNextToTarget = collision.arrivedAtTarget or collidingAgainstPersonNextToTarget
	var isColliding: bool = get_slide_collision_count() > 0
	var targetNotMoving: bool = pb.party_target_vel.length() <= 5
	var withinRadius: bool = target_dist <= pb.active_actors_count*10
	var nextToTarget: bool = target_dist <= 25
	arrivedAtTarget = nextToTarget or (targetNotMoving and withinRadius and isColliding and collidingAgainstPersonNextToTarget)
	if !arrivedAtTarget:
		var seek_target = SBL.arrive(get_global_position(), pb.party_target_pos, stopdist)
		steering_vector_array.append(seek_target)



func state_process_aggressive():
	## If no enemies is in sight (FOV_enemy_list.is_empty()), go to passive
	## If there is enemy in sight (!FOV_enemy_list.is_empty()), sort through list to erase dead enemies
	## If there is alive enemies left over, sort by distance and get the nearest enemy
	## Move towards enemy
	## If in weapon range, attack enemy
	var stopdist: float = GlobalSettings.UNIT * 0.9
	var target_enemy
	if FOV_enemy_list.is_empty():
		change_state(states.PASSIVE)
	elif !FOV_enemy_list.is_empty():
		for enemy in FOV_enemy_list:
			if !enemy.isAlive:
				FOV_enemy_list.erase(enemy)
		if !FOV_enemy_list.is_empty():
			target_enemy = FOV_enemy_list[0]
			var dist_to_nearest_target: float = self.get_global_position().distance_squared_to(target_enemy.get_global_position())
			for enemy in FOV_enemy_list:
				var dist_to_enemy: float = self.get_global_position().distance_squared_to(enemy.get_global_position())
				if dist_to_enemy < dist_to_nearest_target :
					target_enemy = enemy
					dist_to_nearest_target = dist_to_enemy
			var target_pos: Vector2 = target_enemy.get_global_position()
			var seek_target = SBL.arrive(get_global_position(), target_pos, stopdist)
			steering_vector_array.append(seek_target)
			for weapon in weapon_array:
				if is_instance_valid(weapon) and dist_to_nearest_target <= (weapon.attack_range*weapon.attack_range):
					weapon.attack()
	if !isAlive:
		change_state(states.DEAD)


func state_process_hurt():
	pass



func state_process_dead():
	pb.active_actors.erase(self)
	collbody.set_disabled(true)
	if is_instance_valid(weapon_marker):
		weapon_marker.queue_free()
#	self.queue_free()




#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func _on_fov_area_body_entered(body: Node2D) -> void:
	if body != self and body.pb.party_group != self.pb.party_group and body.isAlive:
		if FOV_enemy_list.is_empty():
			EnemySpotted.emit(body)
		FOV_enemy_list.append(body)
		var enemy_distance_squared: float = get_global_position().distance_squared_to(body.get_global_position())
		for enemy in FOV_enemy_list:
			var dist: float = get_global_position().distance_squared_to(enemy.get_global_position())
			if enemy_distance_squared > dist:
				enemy_distance_squared = dist



func _on_fov_area_body_exited(body: Node2D) -> void:
	if body != self and body.pb.party_group != self.pb.party_group:
		FOV_enemy_list.erase(body)



func _on_enemy_spotted(body) -> void:
	if current_state != states.AGGRESSIVE:
		change_state(states.AGGRESSIVE)
		get_tree().call_group(pb.party_id, "_on_fov_area_body_entered", body)
