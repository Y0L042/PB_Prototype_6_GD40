extends Control

@onready var btn_ref := %Btn_Ref

@onready var btn_Choice1 := %"Choice 1"
@onready var btn_Choice2 := %"Choice 2"




signal EoL_choice


func _on_choice_1_pressed():
	EoL_choice.emit(1)


func _on_choice_2_pressed():
	EoL_choice.emit(2)


func add_level_choice_button(level_meta):
	var new_button = Button.new()
	new_button.text = level_meta.level_name
	new_button.pressed.connect(self._button_pressed)
	btn_ref.add_child(new_button)

