extends Node2D

class_name PartyManager

#-------------------------------------------------------------------------------
# Party Properties
#-------------------------------------------------------------------------------
@export var spawn_actors_manually: bool = false
@export var actor_amount: int

var party_blackboard = {
	"party_group": null,
	"all_actors": [],
	"active_actors": [],
	"party_pos": null,
	"party_target_pos": null,
	"party_target_vel": null,
	"active_actor_count": null,
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
	party_blackboard.party_pos = new_spawn_pos
	party_blackboard.party_target_vel = party_blackboard.party_pos # temp
	party_blackboard.active_actor_count = new_actor_count
	party_blackboard.party_group = get_groups()[0]


func spawn_party_actors():
	for actor in party_blackboard.active_actor_count:
		actor.spawn(SceneLib.KNIGHT, Tools.random_offset(party_blackboard.party_pos, 50))


#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func spawn_actor(actor_type, spawn_location: Vector2 = Vector2.ZERO):
		var actor = SceneLib.spawn_child(actor_type, self)
		var spawn_data := ActorSpawnData.new()
		spawn_data.party_manager = self
		spawn_data.party_blackboard = party_blackboard
		spawn_data.spawn_pos = spawn_location
		actor.spawn(spawn_data)


func calc_actor_array_center(arr: Array):
	var avg := Vector2.ZERO
	for actor in arr:
		avg += actor.get_global_position()
	avg /= arr.size()
	return avg

