extends TileMap

@onready var noise_sprite = %Noise
@onready var noise_texture = noise_sprite.get_texture()

@export @onready var WIDTH: int = noise_texture.width #512
@export @onready var HEIGHT: int = noise_texture.height #512

@onready var noise_source = noise_texture.get_noise()

const TILES =  {
	"WHITE": Vector2i(0,0),
	"BLACK": Vector2i(1,0),
}

func _ready() -> void:
	generate_map(noise_source)



func generate_map(noise):
	for x in WIDTH:
		for y in HEIGHT:
			var tile = get_tile_index(noise.get_noise_2d(float(x), float(y)))
			set_cell(0, Vector2i(x, y), 1, tile)


func get_tile_index(noise_sample):
	if noise_sample < 0.1:
		return TILES.BLACK
	return TILES.WHITE


func create_noise():
	var noise
	randomize()
	noise = FastNoiseLite.new()
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	noise.set_seed(randi())
	return noise
