extends BaseMapScript

class_name BaseRandWaveAttackMapScript

@onready var OpenTheGates = %OpenTheGates

@export var enemy_actors_min: int = 1 # make markers with this property
@export var enemy_actors_max: int = 2
@export var enemy_actor_increment: int = 1

var enemy_parties_array: Array
var spawn_timer

var open_the_gates: bool = false

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	if !open_the_gates:
		return
	rand_wave_spawner()

func rand_wave_spawner():

	if enemy_parties_array.size() < 10 and (spawn_timer == null or spawn_timer.get_time_left() < 1):
		enemy_spawns.get_children().shuffle()
		if enemy_actors_min < 40: enemy_actors_min += enemy_actor_increment
		if enemy_actors_max < 50: enemy_actors_max += enemy_actor_increment
		spawn_enemy_party(enemy_spawns.get_children()[randi()%enemy_spawns.get_children().size()].get_global_position())
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
#			ConditionSignal.emit()
			pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.pb.party_group == "Player":
		open_the_gates = true
		OpenTheGates.queue_free()

