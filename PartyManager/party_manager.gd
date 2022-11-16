extends Node2D

class_name PartyManager

#-------------------------------------------------------------------------------
# Party Properties
#-------------------------------------------------------------------------------
@export var spawn_actors_manually: bool = false
@export var actor_amount: int
@export var party_speed: int : set = set_party_speed
@export_color_no_alpha var party_colour: Color
@export var formation_width: int = 5
var formation: GridObject = GridObject.new()
signal allActorsDead

var pb: Dictionary = {
	"main_game": null,
	"party_group": null,
	"party_id": null,
	"all_actors": [],
	"active_actors": [],
	"party_pos": Vector2.ZERO,
	"party_target_pos": Vector2.ZERO,
	"party_target_vel": Vector2.ZERO,
	"active_actors_count": 0,
	"party_max_speed": Vector2.ZERO,
	"party_shader_colour": null,
	"party_formation": formation,
}


#-------------------------------------------------------------------------------
# Custom Classes
#-------------------------------------------------------------------------------
class ActorSpawnData:
	var party_manager: PartyManager
	var party_blackboard: Dictionary
	var spawn_pos: Vector2

#-------------------------------------------------------------------------------
# SetGEt
#-------------------------------------------------------------------------------
func set_party_speed(party_speed):
	party_speed *= GlobalSettings.UNIT

func set_formation(width, num_of_pos, new_position, spacing = 1):
	formation.width = width
	formation.number_of_positions = num_of_pos
	formation.vector_array = GridObject.generate_box_grid(formation)
	GridObject.set_grid_spacing(formation.vector_array, spacing)
	GridObject.set_grid_center_position(formation.vector_array, new_position)



func set_formation_width(width):
	formation_width = width

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func spawn(new_spawn_pos: Vector2 = Vector2.ZERO, new_actor_count: int = 0, new_main_game = null):
	pb.main_game = new_main_game
	pb.party_pos = new_spawn_pos
	pb.party_target_pos = pb.party_pos # temp
	pb.active_actors_count = new_actor_count
	pb.party_group = get_groups()[0]
	pb.party_id = str(self.get_instance_id())
	pb.party_shader_colour = party_colour
	spawn_party_actors()


func spawn_party_actors():
	var actor_type_array: Array
	for index in pb.active_actors_count:
		actor_type_array.append(SceneLib.KNIGHT)
	spawn_actor_array(actor_type_array)
#		spawn_actor(SceneLib.KNIGHT, Tools.random_offset(pb.party_pos, GlobalSettings.UNIT * 5))



#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	pb.party_pos = calc_actor_array_center(pb.active_actors)
	party_process(delta)



func move_party_target(position: Vector2):
	pb.party_target_pos = position
	pb.party_target_vel = pb.party_pos.direction_to(pb.party_target_pos) * party_speed
	pb.party_formation.set_grid_center_position(pb.party_formation.vector_array, pb.party_target_pos)


func party_process(delta: float):
	pass


#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func give_actors_more_weapons(new_weapon):
	for actor in pb.active_actors:
		actor.spawn_weapon(new_weapon)

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------
func spawn_actor_array(actor_spawn_array):
	var new_position: Vector2 = pb.party_pos
	set_formation(formation_width, actor_spawn_array.size(), new_position, 1)
	for actor_index in actor_spawn_array.size():
		spawn_actor(actor_spawn_array[actor_index], formation.vector_array[actor_index])

func spawn_actor(actor_type, spawn_location: Vector2 = Vector2.ZERO):
		var actor = SceneLib.spawn_child(actor_type, self)
		pb.active_actors.append(actor)
		pb.all_actors.append(actor)
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

