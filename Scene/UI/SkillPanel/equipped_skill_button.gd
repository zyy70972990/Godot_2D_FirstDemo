extends Button
class_name EquippedSkillButton
@export var number: int 

@onready var empty: Panel = $Empty
@onready var Skill_icon: TextureRect = $Skill_icon
@onready var label: Label = $Label


var equipped_data: SkillData


func _ready() -> void:
	label.text = str(number)
	
func equip_skill(data: SkillData) -> void:
	equipped_data = data
	empty.hide()
	Skill_icon.texture = data.icon
	Skill_icon.show()
	
func reset_skill_button() ->void:
	empty.show()
	Skill_icon.hide()
	


func _on_pressed() -> void:
	if equipped_data:
		GameData.skill_slots[number-1] = null
		equipped_data = null
		reset_skill_button()
