extends PartyManager

class_name PlayerPartyManager

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _ready() -> void:
	if spawn_actors_manually:
		var spawn_pos: Vector2 = get_node("SpawnPos").get_global_position()
		set_party_blackboard(actor_amount, spawn_pos)
		spawn_party_actors()


