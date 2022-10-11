extends TileMap

@export var borders := Rect2(1,1, 38,21)
@export var start_pos := Vector2(19, 11)
@export var total_steps: int = 500


func _ready() -> void:
	generate_level()


func generate_level():
	var walker = Walker.new(start_pos, borders)
	var map = walker.walk(total_steps)
	walker.queue_free()
	for location in map:
		set_cell(0, location, 1, Vector2i(0, 0))
	force_update(0)
