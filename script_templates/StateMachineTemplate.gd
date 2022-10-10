extends Node2D

class_name StateMachine

#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
enum States {

}

@export var default_state: States
var current_state = default_state


#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------




#-------------------------------------------------------------------------------
# State Machine
#-------------------------------------------------------------------------------
func change_state(NEW_STATE: States):#: int):
	current_state = NEW_STATE

func state_process():
	pass


#-------------------------------------------------------------------------------
# State Functions
#-------------------------------------------------------------------------------
func state_process_passive():
	pass

func state_process_aggressive():
	pass

func state_process_hurt():
	pass

func state_process_dead():
	pass