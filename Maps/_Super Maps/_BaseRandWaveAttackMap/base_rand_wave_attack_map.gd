extends BaseMapScript

class_name BaseRandWaveAttackMapScript

@export var enemy_actors_min: int = 1 # make markers with this property
@export var enemy_actors_max: int = 2
@export var enemy_actor_increment: int = 5

var enemy_parties_array: Array
var spawn_timer


func _ready():
	await get_tree().create_timer(0.5).timeout
	for spawn_marker in enemy_spawns.get_children():
		spawn_enemy_party(spawn_marker.get_global_position())

func rand_wave_spawner():
	if enemy_parties_array.size() < 10 and spawn_timer.get_time_left() < 1:
		enemy_spawns.get_children().shuffle()
		spawn_enemy_party(enemy_spawns.get_children()[0].get_global_position())
		spawn_timer = get_tree().create_timer(10)

func spawn_enemy_party(location: Vector2):
	var party: Variant = spawn_enemies(location)
	party.allActorsDead.connect(_all_actors_dead)
	enemy_parties_array.append(party)

func spawn_enemies(spawn_location):
	var enemy_actors: int = randi_range(enemy_actors_min, enemy_actors_max)
	var enemy_party_manager = SceneLib.spawn_child(SceneLib.ENEMY_PARTY, get_parent())#self)
	enemy_party_manager.spawn(spawn_location, enemy_actors)
	return enemy_party_manager

func _all_actors_dead(party):
	if enemy_parties_array.has(party):
		enemy_parties_array.erase(party)
		if enemy_parties_array.is_empty():
			ConditionSignal.emit()
