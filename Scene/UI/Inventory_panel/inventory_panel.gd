extends PanelContainer
class_name InventoryPanel

@export var grabbed_slot: InventorySlot

@onready var grid_container: GridContainer = %GridContainer
@onready var gold_label: Label = %GoldLabel

var slots: Array[InventorySlot]
var selected_slot_index: int = -1


func _ready() -> void:
	Inventory.on_inventory_changed.connect(_on_inventory_changed)
	for i in grid_container.get_child_count():
		var slot: InventorySlot = grid_container.get_child(i)
		slot.on_slot_clicked.connect(_on_slot_clicked)
		slot.on_slot_hovered.connect(_on_slot_hovered)
		slot.slot_index = i
		slots.append(slot)

func _process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position()

func _on_inventory_changed()-> void:
	for i in slots.size():
		var slot: SlotData = Inventory.get_slot(i)
		slots[i].load_data(slot)


func select_slot(slot_index: int) -> void:
	deselect_slot()
	selected_slot_index = slot_index
	var slot:SlotData = Inventory.get_slot(slot_index)
	grabbed_slot.load_data(slot)
	grabbed_slot.show()

func deselect_slot() ->void:
	selected_slot_index = -1
	grabbed_slot.hide()

func handle_left_button(slot_index: int) -> void:
	#已确定先选格子(有效)，且后选格子不同
	if selected_slot_index >= 0 and selected_slot_index != slot_index:
		var from_item = Inventory.get_slot_item(selected_slot_index)
		var to_item = Inventory.get_slot_item(slot_index)
		
		if from_item == to_item and from_item == to_item:
			Inventory.merge_slots(selected_slot_index,slot_index)
		else:
			Inventory.swap_slots(selected_slot_index,slot_index)	
		
		deselect_slot()
		
	else:
		#已确定先选格子，后选格子相同
		if selected_slot_index == slot_index:
			deselect_slot()
		
		#未确定先选格子
		else:
			if Inventory.get_slot(slot_index):
				select_slot(slot_index)
				
func handle_right_button(slot_index: int) -> void:
	var item = Inventory.get_slot_item(slot_index)
	if not item: return
	
	if item is EquipData:
		Inventory.equip_item(slot_index)
		
	elif Inventory.can_use_item(slot_index):
		Inventory.use_item(slot_index)
		EventBus.on_inventory_used_item.emit(item)
	
func _on_slot_clicked(slot_index: int, button: int) ->void:
	match button:
		MOUSE_BUTTON_LEFT:
			handle_left_button(slot_index)
		MOUSE_BUTTON_RIGHT:
			handle_right_button(slot_index)
		
	
func _on_slot_hovered(slot_index: int) -> void: 
	pass
