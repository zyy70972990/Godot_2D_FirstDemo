extends Button
class_name EquippedSkillButton
@export var number: int 

@onready var empty: Panel = $Empty
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _ready() -> void:
	label.text = str(number)
	
