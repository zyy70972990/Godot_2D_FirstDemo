extends Control
class_name QuestPanel

@onready var quest_button_container: VBoxContainer = %QuestButtonContainer



@export var quests: Array[QuestData]


func _ready() -> void:
	for quest_button: QuestButton in quest_button_container.get_children():
		quest_button.queue_free()
	
	create_quest_buttons()
	
func create_quest_buttons() -> void:
	for quest: QuestData in quests:
		var quest_button_created: QuestButton = Ref.QUEST_BUTTON_SCENE.instantiate()
		quest_button_container.add_child(quest_button_created)
		quest_button_created.setup(quest)


func _on_close_button_pressed() -> void:
	hide()
