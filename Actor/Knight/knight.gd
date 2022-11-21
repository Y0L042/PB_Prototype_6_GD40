extends Actor

class_name KnightActor

var self_scene := SceneLib.KNIGHT

#-------------------------------------------------------------------------------
# Action Functions
#-------------------------------------------------------------------------------
func attack(enemy):
	pass

func pursue(enemy):
	pass

func disengage():
	pass

func move_to(target):
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
	set_conditions
	check_conditions()
	bt()



@onready var is_recalled_to_party: bool = false
@onready var is_called_to_attack: bool = false
@onready var is_party_attacking: bool = false
@onready var is_engaged: bool = false
@onready var is_attack_possible: bool = false
@onready var dist_to_party_LIMIT: float = 5 * GlobalSettings.UNIT

func set_conditions():
	if !enemy_array.is_empty():
		enemy = enemy_array[0]
	else:
		enemy = null
	for _enemy in enemy_array:
		if get_global_position().distance_squared_to(_enemy.get_global_position()) < \
		get_global_position().distance_squared_to(enemy.get_global_position()):
			enemy = _enemy
	if enemy != null:
		var enemy_dist_sqrd: float = get_global_position().distance_squared_to(enemy.get_global_position())
		if enemy_dist_sqrd <= trigger_range*trigger_range:
			is_enemy_in_trigger_range = true
		else:
			is_enemy_in_trigger_range = false

		if enemy_dist_sqrd <= effective_range_max*effective_range_max and enemy_dist_sqrd >= effective_range_min*effective_range_min:
			is_enemy_in_effective_range = true
		else:
			is_enemy_in_effective_range = false

		if enemy_dist_sqrd <= sight_range*sight_range:
			is_enemy_in_sight_range = true
		else:
			is_enemy_in_sight_range = false

func check_conditions():
	if is_enemy_in_trigger_range:
		is_engaged = true # triggered_state

	if is_engaged and !is_enemy_in_sight_range:
		is_engaged = false # triggered_state

	if is_party_attacking:
		is_called_to_attack = true # triggered_state
	else:
		is_called_to_attack = false # triggered_state

	if is_enemy_in_sight_range:
		if is_engaged or is_called_to_attack:
			is_attack_possible = true # set_state
		else:
			is_attack_possible = false # set_state

	if get_global_position().distance_squared_to(move_target) > dist_to_party_LIMIT and is_engaged:
		is_recalled_to_party = true
		is_engaged = false
	else:
		is_recalled_to_party = false

func bt():
	if is_recalled_to_party:
		disengage()
	elif is_attack_possible:
		attack(enemy)
	elif is_engaged and !is_enemy_in_effective_range and is_enemy_in_sight_range:
		pursue(enemy)
	else:
		move_to(move_target)



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
		if enemy_array.is_empty():
			EnemySpotted.emit(body)
		enemy_array.append(body)
		var enemy_distance_squared: float = get_global_position().distance_squared_to(body.get_global_position())
		for enemy in enemy_array:
			var dist: float = get_global_position().distance_squared_to(enemy.get_global_position())
			if enemy_distance_squared > dist:
				enemy_distance_squared = dist
		enemy = enemy_array[0]



func _on_fov_area_body_exited(body: Node2D) -> void:
	if body != self and body.pb.party_group != self.pb.party_group:
		enemy_array.erase(body)



func _on_enemy_spotted(body) -> void:
	if current_state != states.AGGRESSIVE:
		change_state(states.AGGRESSIVE)
		if !isPlayer:
			get_tree().call_group(pb.party_id, "_on_fov_area_body_entered", body)
