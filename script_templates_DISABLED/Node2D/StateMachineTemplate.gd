extends Node2D

class_name _CLASS_

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
	if current_state == States.PASSIVE:
		state_process_passive()
	if current_state == States.AGGRESSIVE:
		state_process_aggressive()
	if current_state == States.HURT:
		state_process_hurt()
	if current_state == States.DEAD:
		state_process_dead()


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
