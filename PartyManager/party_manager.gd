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
	"party_pos": Vector2.ZERO,
	"party_target_pos": Vector2.ZERO,
	"party_target_vel": Vector2.ZERO,
	"active_actors_count": 0,
	"party_max_speed": Vector2.ZERO,
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
func spawn(new_spawn_pos: Vector2 = Vector2.ZERO, new_actor_count: int = 0):
	pb.party_pos = new_spawn_pos
	pb.party_target_pos = pb.party_pos # temp
	pb.active_actors_count = new_actor_count
	pb.party_group = get_groups()[0]
	spawn_party_actors()


func spawn_party_actors():
	for index in pb.active_actors_count:
		spawn_actor(SceneLib.KNIGHT, Tools.random_offset(pb.party_pos, 50))



#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	pass
	move_party_target(delta)
#	for actor in pb.active_actors:
#		actor.managed_process()



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

