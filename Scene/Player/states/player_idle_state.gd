extends PlayerState
class_name PlayerStateIdle


func enter_state() -> void:
	player.play_direction_animation("idle")
	
func process_state(delta: float) ->void:
	pass
	

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("attack"):
		fsm._transition_to("Attack")
		return 
	if player.is_moving():
		fsm._transition_to("Walk")
		
