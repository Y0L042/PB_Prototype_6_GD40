extends BaseMapScript


func _ready() -> void:
	print("rest map spawned")
	await get_tree().create_timer(2.0).timeout # replace with healing or something
	ConditionSignal.emit()
