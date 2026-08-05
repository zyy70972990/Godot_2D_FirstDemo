extends Button
class_name EquipmentSlot
signal on_slot_clicked(slot:EquipmentSlot,button: int)

@export var equip_type: EquipData.EquipType
@onready var item_icon: TextureRect = $ItemIcon

var equipped_data: EquipData 

func _ready() -> void:
	clear_slot()
	gui_input.connect(_on_gui_input)


func load_data(data: EquipData) ->void:
	equipped_data = data
	if data:
		item_icon.texture = data.icon
		item_icon.show()
	else:
		clear_slot()

func clear_slot() ->void:
	equipped_data = null
	item_icon.hide()



func _on_gui_input(event: InputEvent) -> void:
	if  event is InputEventMouseButton and event.is_pressed():
		if equipped_data:
			on_slot_clicked.emit(equipped_data,event.button_index)
		else:
			return
