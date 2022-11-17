extends PartyManager

class_name PlayerPartyManager


var necromance_queue: Array
#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func move_target(delta: float):
	var vel: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down", 0.5).normalized() * party_speed
	var party_target_pos = pb.party_target_pos + (vel * delta)
#	if party_target_pos.distance_to(pb.party_pos) > 1000:
#		return pb.party_target_pos
	rotate_formation(delta)
	return party_target_pos


func party_process(delta: float):
	if pb.active_actors.is_empty():
		allActorsDead.emit(self)
	move_party_target(move_target(delta))
	if !necromance_queue.is_empty():
		necromance()




#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func add_defeated_party_actors(new_party_actors):
	necromance_queue.append(new_party_actors)

func necromance():
	var spawn_type_array: Array = []
	var erase_queue: Array
	for party in necromance_queue:
		for actor in party:
			spawn_type_array.append(actor.self_scene)
			party.erase(actor)
		spawn_actor_array(spawn_type_array)
		necromance_queue.erase(party)

func _input(_event: InputEvent) -> void:
	var clk_pressed = Input.is_action_pressed("ui_rotate_clockwise")
#	var clk_released = Input.is_action_just_released("ui_rotate_clockwise")
	rot_clk = clk_pressed# or clk_released
	var anticlk_pressed = Input.is_action_pressed("ui_rotate_anticlockwise")
#	var anticlk_released = Input.is_action_just_released("ui_rotate_anticlockwise")
	rot_anticlk = anticlk_pressed# or anticlk_released



func rotate_formation(delta: float):
	var rotation_speed: float = 135
#	rotation_speed = lerp(0.0, rotation_speed, 0.5)
	rotation_speed *= delta
	if rot_clk:
		GridObject.set_grid_rotation(pb.party_formation.vector_array, rotation_speed)
	if rot_anticlk:
		GridObject.set_grid_rotation(pb.party_formation.vector_array, -rotation_speed)


























































