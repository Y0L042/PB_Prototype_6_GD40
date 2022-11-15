extends BaseMapScript

class_name BaseRandWaveAttackMapScript

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@onready var OpenTheGates = %OpenTheGates
@onready var spawn_shape = %SpawnShape

@export var enemy_actors_min: int = 10 # make markers with this property
@export var enemy_actors_max: int = -5
@export var enemy_actor_increment: int = 1

var enemy_parties_array: Array
var spawn_timer

var open_the_gates: bool = false



#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	randomize()


#-------------------------------------------------------------------------------
# Runitme
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if !open_the_gates:
		return
	rand_wave_spawner()


#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func rand_wave_spawner():
	if enemy_parties_array.size() < 10 and (spawn_timer == null or spawn_timer.get_time_left() < 1):
		var rand_pos_x: int
		var rand_pos_y: int
		var shape_pos: Vector2 = spawn_shape.get_shape().get_rect().position + spawn_shape.get_global_position()
		var shape_end: Vector2 = spawn_shape.get_shape().get_rect().end + spawn_shape.get_global_position()
		while true:
			rand_pos_x = randi_range(shape_pos.x, shape_end.x)
			rand_pos_y = randi_range(shape_pos.y, shape_end.y)
			var dist_squared: int = Vector2(rand_pos_x, rand_pos_y).distance_squared_to(main_game.player_party_manager.pb.party_pos)
			var limit: int = GlobalSettings.UNIT * GlobalSettings.UNIT * 15 * 15
			if  limit < dist_squared:
				break
		var player_party_size = main_game.player_party_manager.pb.active_actors.size() #-Determine enemy party size based on player party size
		var size: int = clampi(randi_range(enemy_actors_min, enemy_actors_max), 1, 50)
		spawn_enemy_party(Vector2(rand_pos_x, rand_pos_y), size)
		spawn_timer = get_tree().create_timer(2)


func spawn_enemy_party(location: Vector2, size):
	var party: Variant = spawn_enemies(location, size)
	party.allActorsDead.connect(_all_actors_dead)
	enemy_parties_array.append(party)


func spawn_enemies(spawn_location, size):
	var enemy_party_manager = SceneLib.spawn_child(SceneLib.ENEMY_PARTY, get_parent())#self)
	enemy_party_manager.spawn(spawn_location, size, main_game)
	return enemy_party_manager


func _all_actors_dead(party):
	if enemy_parties_array.has(party):
		enemy_parties_array.erase(party)
		if enemy_parties_array.is_empty():
#			ConditionSignal.emit()
			pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.pb.party_group == main_game.player_party_manager.pb.party_group:
		open_the_gates = true
		OpenTheGates.queue_free()

