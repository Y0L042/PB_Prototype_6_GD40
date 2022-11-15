extends BaseWorld

class_name WorldWasteland

var start_map :=  load("res://Maps/World_Wasteland/Start Map/wasteland_start_map.tscn")

var standard_battle_map_list: Array = [
	load("res://Maps/World_Wasteland/Standard Battle Maps/Variant 1/std_battle_map_variant_1.tscn"),
]
var random_std_battle_map = standard_battle_map_list[randi()%standard_battle_map_list.size()]

var rest_map := load("res://Maps/_Super Maps/_BaseRestMap/base_rest_map.tscn")

var rand_wave_map := load("res://Maps/_Super Maps/_BaseRandWaveAttackMap/base_rand_wave_attack_map.tscn")

func _init() -> void:
	LEVEL_ORDER = [
		start_map,
		rand_wave_map,
		random_std_battle_map,
		random_std_battle_map,
		random_std_battle_map,
		rest_map,
		random_std_battle_map,
	]
