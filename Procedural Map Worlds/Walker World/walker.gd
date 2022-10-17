extends Node

class_name Walker

#-------------------------------------------------------------------------------
# Interface Properties
#-------------------------------------------------------------------------------
@export var max_corridor_length: int = 14
@export var random_turn_chance: float = 0
@export var room_min: int = 4
@export var room_max: int =  12

#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history: Array
var steps_since_turn = 0
var rooms = []


#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func _init(starting_position: Vector2, new_borders: Rect2, room_size_range: Vector2):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	room_min = room_size_range.x
	room_max = room_size_range.y


#-------------------------------------------------------------------------------
# Walker Functions
#-------------------------------------------------------------------------------
func walk(steps: int, max_corridor_length = max_corridor_length, random_turn_chance = random_turn_chance):
	place_room(position)
	for i_step in steps:
		if steps_since_turn >= max_corridor_length or randf_range(0, 1) <= random_turn_chance:
			change_direction()

		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history



func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false



func change_direction():
	place_room(position)
	steps_since_turn = 0 #resets steps
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front() # grab a direction. if direction is not in borders, grab another
	while not borders.has_point(position + direction):
		direction = directions.pop_front()



func create_room(pos: Vector2, size: Vector2):
	return {position = pos, size = size}



func place_room(pos: Vector2):
	var size = Vector2(randi() % room_max + room_min, randi() % room_max + room_min)
	var top_left_corner = (pos - size/2).ceil()
	rooms.append(create_room(pos, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)



func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room





