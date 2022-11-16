extends Node

class_name GridObject


#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
var width: int
var number_of_positions: int




#-------------------------------------------------------------------------------
# Grid Tools
#-------------------------------------------------------------------------------
static func generate_box_grid(grid_object: GridObject) -> PackedVector2Array:
	var grid: PackedVector2Array

	var width := grid_object.width
	var volume := grid_object.number_of_positions
	var height := ceili(volume/width)

	for x in width:
		for y in height:
			# add hollow grid
			var pos = Vector2(x, y)

			grid.append(pos)

	return grid

