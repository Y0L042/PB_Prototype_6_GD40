extends Actor

class_name KnightActor

var self_scene := SceneLib.KNIGHT

#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
enum states {
	DEAD,
}


#-------------------------------------------------------------------------------
# State Machine
#-------------------------------------------------------------------------------
func change_state(NEW_STATE: int):
	current_state = NEW_STATE

func player_state_process():
	if current_state == states.DEAD:
		state_process_dead()

func enemy_state_process():
	if current_state == states.DEAD:
		state_process_dead()


#-------------------------------------------------------------------------------
# Player State Functions
#-------------------------------------------------------------------------------


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
