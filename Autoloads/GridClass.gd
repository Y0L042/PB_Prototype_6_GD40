extends Node

class_name GridObject


#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var UNIT = GlobalSettings.UNIT # dependency on another library, set to unit pixel size


#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
var width: int : set = set_width
var number_of_positions: int : set = set_number_of_positions
var offset: Vector2 : set = set_offset
var spacing : set = set_spacing
var rotation: float = 0 #: set = set_rotation
var center_position: Vector2 : set = set_center_position

var vector_array: PackedVector2Array
var ref_vector_array: PackedVector2Array

#-------------------------------------------------------------------------------
# SetGet
#-------------------------------------------------------------------------------
func set_width(new_width):
	width = new_width


func set_number_of_positions(new_number_of_positions: int):
	number_of_positions = new_number_of_positions

func set_offset(new_offset):
	offset = new_offset

func set_spacing(new_spacing):
	spacing = new_spacing #* UNIT

func set_rotation(new_rotation):
	rotation = new_rotation
	set_grid_rotation(vector_array, rotation)
	pass

func increment_rotation(rotation_increment):
	set_rotation(rotation + rotation_increment)


func set_center_position(new_center_position: Vector2):
	center_position = new_center_position
	set_grid_center_position(vector_array, center_position)

#-------------------------------------------------------------------------------
# (Static) Grid Tools
#-------------------------------------------------------------------------------
static func get_grid_center(new_grid: PackedVector2Array):
	var new_grid_center: Vector2
	for index in new_grid:
		new_grid_center += index
	new_grid_center /= new_grid.size()
	return new_grid_center


static func set_grid_spacing(new_grid, new_spacing):
	new_spacing *= GlobalSettings.UNIT
	for index in new_grid.size():
		new_grid[index] *= new_spacing


func set_grid_center_position(new_grid, new_position: Vector2):
	var current_grid_center: Vector2 = get_grid_center(new_grid)
	var offset: Vector2 = new_position - current_grid_center
	for index in new_grid.size():
		new_grid[index] += offset


func set_grid_rotation(new_grid, new_rotation: float):
	#uses reference vector array
	new_rotation = deg_to_rad(new_rotation)
	for index in new_grid.size():
		var new_vector: Vector2 = ref_vector_array[index].rotated(new_rotation)
		new_grid[index] = new_vector


func increment_grid_rotation(new_grid, new_rotation: float):
	#uses reference vector array
	new_rotation = deg_to_rad(new_rotation)
	for index in new_grid.size():
		var new_vector: Vector2 = ref_vector_array[index].rotated(new_rotation)
		new_grid[index] = new_vector


func generate_box_grid(grid_object: GridObject) -> PackedVector2Array:
	var grid: PackedVector2Array
	var width: float = grid_object.width
	var volume: float = grid_object.number_of_positions
	var temp: float = volume/width
	var height: float = ceil(temp)
	for y in height:
		for x in width:
			# add hollow grid
			var pos: Vector2
			if int(y) % 2 == 0:
				pos = Vector2(width - x -1, -y)
			else:
				pos = Vector2(x, -y)
			grid.append(pos)
	trim_grid_to_volume(grid, volume)
	set_grid_spacing(grid, spacing)
	ref_vector_array = grid.duplicate() # create ref grid to use for absolute rotations
	set_grid_rotation(grid, rotation)
	return grid

static func trim_grid_to_volume(new_grid, new_volume):
	var offset = new_volume
	for index in (new_grid.size() - new_volume):
		new_grid.remove_at(offset)
