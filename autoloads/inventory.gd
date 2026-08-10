extends Node

signal on_inventory_changed
signal on_equipment_changed

const INVENTORY_SIZE: int = 30

var inventory: Array[SlotData]

func _ready() -> void:
	inventory.clear()
	inventory.resize(INVENTORY_SIZE)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#add_item(preload("uid://fnrj5iympnyy"),10)
	#


#region Find


func find_item_indexes(item:ItemData,with_space: bool =false) ->Array[int]:
	var found:Array[int] = []
	for i in inventory.size():
		var slot = inventory[i]
		if slot and slot.item == item:
			if with_space:
				if slot.quantity < item.max_stack:
					found.append(i)
			else:
				found.append(i)
				
	return found


func count_item(item: ItemData) -> int:
	var total: int = 0
	for slot in inventory:
		if slot and slot.item.name == item.name:
			total += slot.quantity
	return total
	
#endregion

#region add/remove


func add_item(item: ItemData,amount: int = 1) -> void:
	if not item:
		return 
	
	var remaining = amount
	
	#添加物品时先尝试堆叠
	if item.max_stack > 1:
		for index in find_item_indexes(item,true):
			if remaining <= 0:
				break
			
			var slot = inventory[index]
			var space = item.max_stack-slot.quantity
			var to_give = min(space,remaining)
			remaining -= to_give
			slot.quantity += to_give
			
	#如果堆叠后仍然没有装完，则使用空的slot继续添加
	if remaining >0:
		for index in get_empty_slot_indexes():
			if remaining <= 0:
				break
			
			var to_give = min(remaining,item.max_stack)
			inventory[index] = SlotData.new(item,to_give)
			remaining -= to_give
			
	var added = amount - remaining	
	if added > 0:
		on_inventory_changed.emit()

func remove_item(item: ItemData, amount: int) -> void:
	var remaining = amount
	
	var slots = find_item_indexes(item)
	slots.reverse()
	
	for index in slots:
		if remaining <= 0:
			break
		
		var slot: SlotData = inventory[index]
		var take = min(slot.quantity,remaining)
		slot.quantity -= take
		remaining -= take
		
		if slot.quantity <= 0:
			inventory[index] = null
		
	var removed = amount - remaining
	if removed > 0:
		on_inventory_changed.emit()
		
#endregion	

#region swap
func swap_slots(from_index: int ,to_index: int)->void:
	if from_index < 0 or from_index >= inventory.size():
		return
	if to_index < 0 or to_index >= inventory.size():
		return
	
	var temp = inventory[from_index]
	inventory[from_index] = inventory[to_index]	
	inventory[to_index] = temp
	
	on_inventory_changed.emit()
#endregion

#region merge

func merge_slots(from_index:int,to_index:int) -> void:
	var from_slot: SlotData = get_slot(from_index)
	var to_slot: SlotData = get_slot(to_index)
	if not from_slot or not to_slot:
		return 
	if from_slot.item != to_slot.item:
		return 
	
	var item = from_slot.item
	if item.max_stack <= 1:
		return
	
	var space = item.max_stack - to_slot.quantity
	var to_move = min(space,from_slot.quantity)
	
	to_slot.quantity += to_move
	from_slot.quantity -= to_move
	
	if from_slot.quantity <= 0:
		inventory[from_index] = null
	elif space <= 0:
		swap_slots(from_index,to_index)
	
	on_inventory_changed.emit()
	
#endregion
	
	
#region get
func get_slot(index: int) -> SlotData:
	if index >= 0 and index < inventory.size():
		return inventory[index]
	return null

func get_slot_item(index: int) -> ItemData:
	var slot = get_slot(index)
	if slot:
		return slot.item
	return null
	
func get_empty_slot_indexes() -> Array[int]:
	var empty: Array[int] = []
	for i in inventory.size():
		if inventory[i] == null:
			empty.append(i)
	return empty
#endregion

#region Use Item
func use_item(slot_index: int)->void:
	var slot:SlotData = inventory[slot_index]
	if not slot: return
	if not slot.item.is_consumable: return
	
	slot.quantity -= 1
	if slot.quantity <=0:
		inventory[slot_index] = null
	
	on_inventory_changed.emit()
	return
#endregion

#region Can Use Item
func can_use_item(slot_index: int)->bool:
	var slot:SlotData = get_slot(slot_index)
	return slot and slot.item.is_consumable
#endregion
	
#region Equioment

func equip_item(slot_index: int) ->void:
	var slot: SlotData = get_slot(slot_index)
	if not slot:
		return 
	
	if slot.item is not EquipData:
		return
		
	var equip: EquipData = slot.item as EquipData
	var equip_key : String = equip.get_equip_key()
	
	var curr_equipped_data = GameData.equipment[equip_key]
	
	GameData.equipment[equip_key] = equip
	
	inventory[slot_index] = null
	
	if curr_equipped_data:
		add_item(curr_equipped_data,1)
	
	on_inventory_changed.emit()
	on_equipment_changed.emit()
	
func unequip_item(equip_type: EquipData.EquipType) ->void:
	var equip_key = GameData.equipment.keys()[equip_type]
	var equipped_item = GameData.equipment[equip_key]
	
	if not equipped_item:
		return 
	
	add_item(equipped_item,1)
	
	GameData.equipment[equip_key] = null
	on_inventory_changed.emit()
	on_equipment_changed.emit()
#endregion
