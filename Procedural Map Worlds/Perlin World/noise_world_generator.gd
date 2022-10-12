extends Node2D

class_name NoiseWorldGenerator

#@onready var noise_sprite = %Noise
#@onready var noise_texture = noise_sprite.get_texture()
#@onready var WIDTH: int = noise_texture.width
#@onready var HEIGHT: int = noise_texture.height
#@onready var noise_source = noise_texture.get_noise()

@export var white_tile_filter: float = 0.15

var default_noise_resource = preload("res://Procedural Map Worlds/Perlin World/perlin_world_noise.tres")
var WIDTH: int = default_noise_resource.width
var HEIGHT: int = default_noise_resource.height
var default_noise = default_noise_resource.get_noise()

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

func _ready() -> void:
	pass
#	generate_map(noise_source)
#	noise_sprite.set_visible(false)



func generate_map(tilemap: TileMap, noise = default_noise):
	for x in WIDTH:
		for y in HEIGHT:
			var tile = get_tile_index(noise.get_noise_2d(float(x), float(y)))
			tilemap.set_cell(0, Vector2i(x, y), 1, tile)
	tilemap.force_update(0)
	return tilemap


func get_tile_index(noise_sample):
	if noise_sample < white_tile_filter:
		return TILES.WHITE
	return TILES.BLACK


