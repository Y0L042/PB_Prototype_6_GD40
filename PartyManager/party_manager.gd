extends Node2D

class_name PartyManager

#-------------------------------------------------------------------------------
# Party Properties
#-------------------------------------------------------------------------------
@export var spawn_actors_manually: bool = false
@export var actor_amount: int
@export var party_speed: int

var pb = {
	"party_group": null,
	"all_actors": [],
	"active_actors": [],
	"party_pos": null,
	"party_target_pos": null,
	"party_target_vel": null,
	"active_actors_count": null,
	"party_max_speed": null,
	"party_shader_color": null,
}


#-------------------------------------------------------------------------------
# Custom Classes
#-------------------------------------------------------------------------------
class ActorSpawnData:
	var party_manager: PartyManager
	var party_blackboard: Dictionary
	var spawn_pos: Vector2



#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func set_party_blackboard(new_actor_count: int = 0, new_spawn_pos: Vector2 = Vector2.ZERO) -> void:
	pb.party_pos = new_spawn_pos
	pb.party_target_pos = pb.party_pos # temp
	pb.active_actors_count = new_actor_count
	pb.party_group = get_groups()[0]


func spawn_party_actors():
	for index in pb.active_actors_count:
		spawn_actor(SceneLib.KNIGHT, Tools.random_offset(pb.party_pos, 50))



#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	move_party_target(delta)
	for actor in pb.active_actors:
		actor.managed_process()



func move_party_target(delta: float):
	pass
#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func spawn_actor(actor_type, spawn_location: Vector2 = Vector2.ZERO):
		var actor = SceneLib.spawn_child(actor_type, self)
		pb.active_actors.append(actor)
		var spawn_data := ActorSpawnData.new()
		spawn_data.party_manager = self
		spawn_data.party_blackboard = pb
		spawn_data.spawn_pos = spawn_location
		actor.spawn(spawn_data)



func calc_actor_array_center(arr: Array):
	var avg := Vector2.ZERO
	for actor in arr:
		avg += actor.get_global_position()
	avg /= arr.size()
	return avg

