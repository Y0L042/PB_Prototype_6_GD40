extends Control

@onready var btn_Choice1 := %"Choice 1"
@onready var btn_Choice2 := %"Choice 2"


signal EoL_choice


func _on_choice_1_pressed():
	EoL_choice.emit(1)


func _on_choice_2_pressed():
	EoL_choice.emit(2)
