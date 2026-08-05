extends State
class_name EnemyState

@onready var enemy_zones: Node = $EnemyZones

var enemy: Enemy

func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	
