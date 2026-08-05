extends EnemyState
class_name EnemyAttackState

@export var attack_duration := 0.5

var attack_timer := 0.0
var damage_applied := false
var attack_distance_check := 25.0

func enter_state() -> void:
	attack_timer = attack_duration
	damage_applied = false
	
func process_state(delta: float) ->void:
	if not enemy or not Ref.player:
		fsm._transition_to("Wander")
		return
	
	attack_timer -= delta
	if attack_timer <= attack_duration / 2.0 and not damage_applied:
		apply_damage()
		damage_applied = true
	
	if attack_timer <= 0.0:
		fsm._transition_to("Follow")

func apply_damage() -> void:
	var dist = enemy.global_position.distance_to(Ref.player.global_position)
	if dist <= attack_distance_check:
		Ref.player.health_component.take_damage(enemy.damage)
		Ref.create_damage_fx(Ref.player.global_position)
		Ref.create_damage_text(Ref.player.global_position,enemy.damage)
		
