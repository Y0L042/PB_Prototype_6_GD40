extends Node

var rand := RandomNumberGenerator.new()

func random_offset(center_point: Vector2, radius: int) -> Vector2:
	var offset_pos: Vector2 = center_point
	offset_pos.x += randi_range(-radius, radius)
	offset_pos.y += randi_range(-radius, radius)
	return offset_pos

func get_percentage(num, denom):
	var perc = num/denom * 100
	return perc



