extends Actor

class_name KnightActor

var self_scene := SceneLib.KNIGHT

#-------------------------------------------------------------------------------
# Action Functions
#-------------------------------------------------------------------------------
func move_to_target(weight: float = 0.5):
	pass # add velocity to target to array

func move_to_enemy(weight: float = 0.5):
	pass # add velocity to target to array

func move_away_from_enemy(weight: float = 0.5):
	pass # add velocity to target to array

func collision_avoidance_function(weight: float): #add target
	pass


#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
enum states {
	STANDARD,
	DEAD,
}


#-------------------------------------------------------------------------------
# State Machine
#-------------------------------------------------------------------------------
func change_state(NEW_STATE: int):
	current_state = NEW_STATE

func player_state_process():
	if current_state == states.STANDARD:
		state_process_standard()
	if current_state == states.DEAD:
		state_process_dead()

func enemy_state_process():
	if current_state == states.STANDARD:
		state_process_standard()
	if current_state == states.DEAD:
		state_process_dead()


#-------------------------------------------------------------------------------
# State Functions
#-------------------------------------------------------------------------------
func state_process_standard():
	check_conditions()
	bt()

var is_recalled_to_party: bool = false
var is_called_to_attack: bool = false
var is_engaged: bool = false
var is_attack_possible: bool = false

func check_conditions():
	if enemy is in trigger_zone:
		is_engaged = true # triggered_state

	if is_engaged and enemy is not in sight_range:
		is_engaged = false # triggered_state

	if is_party_attacking:
		is_called_to_attack = true # triggered_state
	else:
		is_called_to_attack = false # triggered_state

	if enemy is in effective_range:
		if is_engaged or is_called_to_attack:
			is_attack_possible = true # set_state
		else:
			is_attack_possible = false # set_state

	if distance_to_party_target > LIMIT and is_engaged:
		is_recalled_to_party = true
		is_engaged = false
	else:
		is_recalled_to_party = false

func bt():
	if is_recalled_to_party:
		disengage()
	elif is_attack_possible:
		attack(enemy)
	elif is_engaged and enemy is not in effective_range and enemy is in sight_range:
		pursue(enemy)
	else:
		move_to(party_pos)



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
		if !isPlayer:
			get_tree().call_group(pb.party_id, "_on_fov_area_body_entered", body)
