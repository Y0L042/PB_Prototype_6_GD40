extends BaseMapScript

class_name BaseStandardBattleMapScript

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	ConditionSignal.emit()
