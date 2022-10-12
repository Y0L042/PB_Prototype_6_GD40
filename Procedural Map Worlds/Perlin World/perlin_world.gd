extends TileMap

@onready var noise_sprite = %Noise
@onready var noise_texture = noise_sprite.get_texture()

@onready var WIDTH: int = noise_texture.width
@onready var HEIGHT: int = noise_texture.height

@onready var noise_source = noise_texture.get_noise()

@export var white_tile_filter: float = 0.15

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

func _ready() -> void:
	generate_map(noise_source)
	noise_sprite.set_visible(false)



func generate_map(noise):
	for x in WIDTH:
		for y in HEIGHT:
			var tile = get_tile_index(noise.get_noise_2d(float(x), float(y)))
			set_cell(0, Vector2i(x, y), 1, tile)


func get_tile_index(noise_sample):
	if noise_sample < white_tile_filter:
		return TILES.WHITE
	return TILES.BLACK


