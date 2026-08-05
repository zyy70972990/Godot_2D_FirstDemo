extends PlayerState
class_name PlayerStateAttack


func process_state(delta: float) ->void:
	pass
	

var weapon_rotations: Dictionary = {
	"down" : 180.0,
	"left" : -90.0,
	"right" : 90.0,
	"up" : 0.0
}


func enter_state() -> void:
	var is_looping = player.animated_sprite_2d.sprite_frames.get_animation_loop(player.animated_sprite_2d.animation)
	print(is_looping)
	player.animated_sprite_2d.sprite_frames.set_animation_loop(player.animated_sprite_2d.animation, false)
	
	player.animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	player.play_direction_animation("attack")
	position_weapon()
	

	
func exit_state() -> void:
	if player.animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)

func position_weapon() -> void:
	var direction_key: String = player.last_direction
	var marker:Marker2D = player.attack_positions[direction_key]
	player.weapon.global_position = marker.global_position
	player.weapon.rotation_degrees = weapon_rotations[direction_key]
	
	player.weapon.show()
	player.enable_weapon_collision(true)

func _on_animation_finished() -> void:
	print("Attack finished")
	player.enable_weapon_collision(false)
	player.weapon.hide()
	fsm._transition_to("Idle")


#func _on_animated_sprite_2d_animation_finished() -> void:
	#player.enable_weapon_collision(false)
	#player.weapon.hide()
	#fsm._transition_to("Idle")
	#pass # Replace with function body.
