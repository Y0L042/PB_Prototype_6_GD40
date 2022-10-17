extends RigidBody2D

class_name TinyKeepRoom

var size: Vector2
@onready var collshape := $CollisionShape2D

func make_room(new_pos: Vector2, new_size: Vector2):
	position = new_pos
	size = new_size
	var shape = RectangleShape2D.new()
	shape.custom_solver_bias = 0.75
	shape.extents = new_size
	collshape.shape = shape
