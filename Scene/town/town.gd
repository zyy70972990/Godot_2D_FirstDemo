extends Node2D
class_name Town

@export var player_scene: PackedScene

func _ready() -> void:
	EventBus.on_inventory_used_item.connect(_on_inventory_used_item)
	create_player()
	
func create_player() -> void:
	var player: Player = player_scene.instantiate()
	player.z_index = 10  # 强制显示在上层
	add_child(player)
	player.setup()
	Ref.player = player
	EventBus.on_player_created.emit()


func _on_inventory_used_item(item: ItemData) -> void:
	match item.id:
		"hp_potion": Ref.player.health_component.heal(item.value)
		"mana_potion": Ref.player.add_mana(item.value)
