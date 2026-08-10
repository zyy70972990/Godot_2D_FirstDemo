extends Area2D
class_name DropItem

@export var item: ItemData
@export var amount: int = 1

@export var shine_speed:= 0.6
@export var shine_freq:= 2.0

@onready var sprite_2d_2: Sprite2D = $Sprite2D2

func _ready() -> void:
	setup()

func setup() -> void:
	if item and item.icon:
		sprite_2d_2.texture = item.icon

func load_item(data: LootData) -> void:
	item = data.item
	amount = data.amount
	
func shine_item() -> void:
	var shine_tween := create_tween().set_loops()
	shine_tween.tween_property(sprite_2d_2.material,"shader_parameter/shine_progress",1.0,shine_speed).set_delay(shine_freq)
	shine_tween.tween_property(sprite_2d_2.material,"shader_parameter/shine_progress",0.0,shine_speed)


func _on_body_entered(body: Node2D) -> void:
	Inventory.add_item(item,amount)
	SoundMangaer.play(Sound.PICKUP)
	queue_free()
	
	
	
