extends Node

class_name MapDataObject

# Global Data
var generation_method
var global_tilemap: TileMap
var global_map_size: Vector2

# Walker-Specific Data
var walker_total_steps: int
var walker_corridor_width: int
var walker_room_size_range: Vector2
var walker_corridor_length: int
var walker_turn_chance: float

# Noise-Specific Data
