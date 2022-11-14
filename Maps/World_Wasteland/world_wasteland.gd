extends BaseWorld

class_name WorldWasteland

var Start_Map :=  load("res://Maps/World_Wasteland/Start Map/wasteland_start_map.tscn")
var standard_battle_map_list: Array = [
	load("res://Maps/World_Wasteland/Standard Battle Maps/Variant 1/std_battle_map_variant_1.tscn"),
]

func _init() -> void:
	LEVEL_ORDER = [
		Start_Map,
		standard_battle_map_list[randi()%standard_battle_map_list.size()],
	]
