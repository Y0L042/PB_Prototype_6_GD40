extends BaseMapScript

func _ready():
	await get_tree().create_timer(0.5).timeout
	for spawn_marker in enemy_spawns.get_children():
		spawn_enemies(spawn_marker.get_global_position())

func spawn_enemies(spawn_location):
	var enemy_party_manager = SceneLib.spawn_child(SceneLib.ENEMY_PARTY, get_parent())#self)
	enemy_party_manager.spawn(spawn_location, 10)
