extends Actor

# Classname


#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
enum states {
	PASSIVE,
	AGGRESSIVE,
	HURT,
	DEAD,
}


#-------------------------------------------------------------------------------
# State Machine
#-------------------------------------------------------------------------------
func change_state(NEW_STATE: int):
	current_state = NEW_STATE

func state_process():
	if current_state == states.PASSIVE:
		state_process_passive()
	if current_state == states.AGGRESSIVE:
		state_process_aggressive()
	if current_state == states.HURT:
		state_process_hurt()
	if current_state == states.DEAD:
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
