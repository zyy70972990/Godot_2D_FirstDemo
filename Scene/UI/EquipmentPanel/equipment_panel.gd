extends PanelContainer
class_name EquipmentPanel


@onready var slots: Array[EquipmentSlot] = [
	%HelmetSlot, %WeaponSlot, %BodySlot, %LegSlot, %RingSlot
]

func _ready() -> void:
	for slot in slots:
		slot.on_slot_clicked.connect(_on_slot_clicked)
		Inventory.on_equipment_changed.connect(_on_equipment_changed)

	
func _on_equipment_changed() -> void:
	var items: Array[EquipData] = GameData.equipment.values()
	for i in slots.size():
		slots[i].load_data(items[i])
		
	
func _on_slot_clicked(data:EquipData,button: int) ->void:
	match button:
		MOUSE_BUTTON_RIGHT:
			Inventory.unequip_item(data.equip_type)
			
	

		
