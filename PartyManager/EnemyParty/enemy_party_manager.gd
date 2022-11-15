extends PartyManager

class_name EnemyPartyManager

var change_direction_timer

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	pass
#	if spawn_actors_manually:
#		var spawn_pos: Vector2 = get_node("SpawnPos").get_global_position()
#		spawn(spawn_pos, actor_amount)

func party_process(delta: float):
	if pb.active_actors.is_empty():
		allActorsDead.emit(self)

		#temp
		self.queue_free()
	move_party_target(move_target(delta))


func move_target(delta: float):
	var party_target_pos: Vector2
	var range: int = 100000
	var px: int = randi_range(-range, range)
	var py: int = randi_range(-range, range)
	party_target_pos = Vector2(px, py)
	return party_target_pos


