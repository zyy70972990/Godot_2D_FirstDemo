extends Area2D
class_name Portal


@export var target_transit_pos: Node2D
func _on_body_entered(body: Node2D) -> void:
	await Transition.fade_in(1.0)
	Ref.player.global_position = target_transit_pos.global_position
	Transition.fade_out(1.0)
