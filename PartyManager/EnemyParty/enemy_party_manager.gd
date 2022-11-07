extends PartyManager

class_name EnemyPartyManager

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	if spawn_actors_manually:
		var spawn_pos: Vector2 = get_node("SpawnPos").get_global_position()
		spawn(spawn_pos, actor_amount)



