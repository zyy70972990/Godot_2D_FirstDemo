extends Control
class_name ShopPanel


@export var items: Array[ItemData]

@onready var container: GridContainer = %Container
@onready var total_coin_label: Label = %TotalCoinLabel
@onready var close_button: Button = $CloseButton


func _ready() -> void:
	for button in container.get_children():
		button.queue_free()
	
	load_shop_items()
	total_coin_label.text = str(GameData.coins)

func load_shop_items() -> void:
	
	for item: ItemData in items:
		var shop_button: ShopButton = Ref.SHOP_BUTTON_SCENE.instantiate()
		container.add_child(shop_button)
		shop_button.load_item(item)
		shop_button.on_item_purchased.connect(_on_item_purchased)
		
		
func _on_item_purchased() -> void:
	
	total_coin_label.text = str(GameData.coins)
	
	
	


func _on_close_button_pressed() -> void:
	hide()
