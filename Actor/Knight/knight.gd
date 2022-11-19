extends Actor

class_name KnightActor

var self_scene := SceneLib.KNIGHT
#-------------------------------------------------------------------------------
# Action functions
#-------------------------------------------------------------------------------
func move_to_target(weight: float = 0.5):
	pass # add velocity to target to array

func move_to_enemy(weight: float = 0.5):
	pass # add velocity to target to array

func move_away_from_enemy(weight: float = 0.5):
	pass # add velocity to target to array



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
	pass


#-------------------------------------------------------------------------------
# State Functions
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------

func _on_fov_area_body_entered(body: Node2D) -> void:
	if body != self and body.pb.party_group != self.pb.party_group and body.isAlive:
		if FOV_enemy_list.is_empty():
			EnemySpotted.emit(body)
		FOV_enemy_list.append(body)
		return


		var enemy_distance_squared: float = get_global_position().distance_squared_to(body.get_global_position())
		for enemy in FOV_enemy_list:
			var dist: float = get_global_position().distance_squared_to(enemy.get_global_position())
			if enemy_distance_squared > dist:
				enemy_distance_squared = dist



func _on_fov_area_body_exited(body: Node2D) -> void:
	if body != self and body.pb.party_group != self.pb.party_group:
		FOV_enemy_list.erase(body)




