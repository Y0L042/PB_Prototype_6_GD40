extends PartyManager

class_name EnemyPartyManager



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


