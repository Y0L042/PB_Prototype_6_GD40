extends BaseMapScript

@export var enemy_actors = 1 # make markers with this property

var enemy_parties_array: Array



func _ready():
	await get_tree().create_timer(0.5).timeout
	for spawn_marker in enemy_spawns.get_children():
		var party: Variant = spawn_enemies(spawn_marker.get_global_position())
		party.allActorsDead.connect(_all_actors_dead)
		enemy_parties_array.append(party)


func spawn_enemies(spawn_location):
	var enemy_party_manager = SceneLib.spawn_child(SceneLib.ENEMY_PARTY, get_parent())#self)
	enemy_party_manager.spawn(spawn_location, enemy_actors)
	return enemy_party_manager

func _all_actors_dead(party):
	if enemy_parties_array.has(party):
		enemy_parties_array.erase(party)
		if enemy_parties_array.is_empty():
			ConditionSignal.emit()
