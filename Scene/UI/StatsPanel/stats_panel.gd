extends PanelContainer
class_name StatsPanel

@onready var hp_label: Label = %HPLabel
@onready var vel_label: Label = %VelLabel
@onready var mp_label: Label = %MPLabel
@onready var crit_label: Label = %CritLabel
@onready var crit_dmg_label: Label = %CritDMGLabel
@onready var dmg_label: Label = %DMGLabel


@onready var curr_level_label: Label = %CurrLevelLabel
@onready var curr_points_label: Label = %CurrPointsLabel

@onready var str_points_label: Label = %STRPointsLabel
@onready var dex_points_label: Label = %DEXPointsLabel
@onready var int_points_label: Label = %INTPointsLabel

func _ready() -> void:
	EventBus.on_player_created.connect(_on_player_created)
	EventBus.on_player_stats_updated.connect(_on_player_stats_updated)
func update_stats() ->void:
	if not is_instance_valid(Ref.player):
		return
	dmg_label.text = "DMG: %s" % str(Ref.player.damage)
	hp_label.text = "HP: %s" % str(Ref.player.max_health)
	vel_label.text = "VEL: %s" % str(Ref.player.move_speed)
	mp_label.text = "Mana: %s" % str(Ref.player.max_mana)
	crit_label.text = "Crit: %s" % str(Ref.player.critical_chance)
	crit_dmg_label.text = "Crit DMG: %s" % str(Ref.player.critical_damage)
	curr_level_label.text = "Level %s" % str(Ref.player.curr_level)
	curr_points_label.text = "Points: %s" % str(Ref.player.curr_points)
	str_points_label.text = str(Ref.player.strength_value)
	dex_points_label.text = str(Ref.player.dexterity_value)
	int_points_label.text = str(Ref.player.intelligence_value)

func _on_str_button_pressed() -> void:
	Ref.player.upgrade_stat("STR")


func _on_dex_button_pressed() -> void:
	Ref.player.upgrade_stat("DEX")


func _on_int_button_pressed() -> void:
	Ref.player.upgrade_stat("INT")

func _on_player_created() -> void:
	update_stats()

func _on_player_stats_updated() -> void:
	update_stats()
