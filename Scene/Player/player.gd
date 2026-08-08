extends CharacterBody2D
class_name Player


@export_group("Stats")
@export var max_health: float = 10.0
@export var max_mana: float = 10.0
@export var move_speed: float = 60.0
@export var damage: float = 5.0
@export var critical_chance: float = 0.0
@export var critical_damage: float = 0.0


@export_group("Exp")
@export var base_exp: float = 100.0
@export var exp_multiplier: float = 2.0

@export var curr_exp: float = 0.0
@export var next_level_exp: float
@export var curr_level: int = 1
@export var curr_points: int = 0 

var strength_value: int = 0
var dexterity_value: int = 0
var intelligence_value: int = 0

var selected_enemy: Enemy:
	set(value):
		if selected_enemy:
			selected_enemy.deselect_enemy()
		selected_enemy = value
		selected_enemy.select_enemy()

@onready var fsm: FSM = $FSM
@onready var health_component: HealthComponent = $HealthComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_area: Area2D = %EnemyAttackArea
@onready var weapon: Node2D = $Weapon



@onready var attack_positions: Dictionary = {
	"down":%Down,
	"up":%Up,
	"left":%Left,
	"right":%Right
	
}


var last_direction: String = "down"
var curr_mana: float

	
func _ready() -> void:
	setup()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("ui_accept"):
		health_component.take_damage(1.0)
		use_mana(2.0)
		add_exp(50)
	
	if event.is_action_pressed("skill_1"):
		use_skill(0)
	elif event.is_action_pressed("skill_2"):
		use_skill(1)
	elif event.is_action_pressed("skill_3"):
		use_skill(2)
	elif event.is_action_pressed("skill_4"):
		use_skill(3)
		

		


func _process(delta: float) -> void:
	if fsm.curr_state:
		fsm.curr_state.process_state(delta)
		
		


func use_skill(index: int) ->void:
	if index < 0 or index >= GameData.skill_slots.size():
		return
	
	var skill: SkillData = GameData.skill_slots[index]
	if not skill: return
	if not selected_enemy: return
	if curr_mana < skill.mana_cost: return
	
	use_mana(skill.mana_cost)
	var total_dmg = get_damage(skill.base_dmg)
	selected_enemy.health_component.take_damage(total_dmg)
	
	var exp_effect: Node2D = skill.explosion_effect.instantiate()
	exp_effect.global_position = selected_enemy.global_position
	get_tree().root.add_child(exp_effect)
	Ref.create_damage_text(selected_enemy.global_position,total_dmg)
	
		
func is_moving() -> bool:
	var moving_input:Array = ["move_down","move_up","move_left","move_right"]
	for input in moving_input:
		if Input.is_action_pressed(input):
			return true
	return false
	
func update_direction(input_vector: Vector2) -> void:
	if input_vector == Vector2.ZERO:
		return 
	
	if abs(input_vector.x) > abs(input_vector.y):
		last_direction = "right" if input_vector.x > 0 else "left"
	else:
		last_direction = "down" if input_vector.y > 0 else "up"
		#play_direction_animation("idle")
func play_direction_animation(animation_name: String) -> void:
	animated_sprite_2d.play("%s_%s" % [animation_name,last_direction])
	
func add_exp(value: float)->void:
	curr_exp += value
	while curr_exp >= next_level_exp:
		level_up()	

	EventBus.on_player_new_level.emit(curr_exp,next_level_exp)

func upgrade_stat(stat_name: String) -> void:
	if curr_points <= 0:
		return 
	
	curr_points -= 1
	
	match stat_name:
		"STR":
			strength_value += 1
			damage += 1.5
			max_health += 3.0
			reset_health()
		"DEX":
			dexterity_value += 1
			move_speed += 2.0
			critical_chance =+ 2.0
		"INT":
			intelligence_value += 1
			max_mana += 15.0
			critical_damage += 5
			reset_mana()
			get_damage()
	EventBus.on_player_stats_updated.emit()


func get_damage(skill_dmg: float = 0.0) -> float:
	var total_dmg = damage + skill_dmg
	
	# Add damage of each equipment
	for equip: EquipData in GameData.equipment.values():
		if equip:
			total_dmg += equip.bonus_damage
	
	# check our critical attack
	if randf() * 100 <= critical_chance:
		total_dmg *= (1.0 + (critical_damage / 100.0))
		
	return total_dmg
	
func level_up() -> void:
	curr_exp -= next_level_exp
	curr_level += 1
	curr_points += 4
	next_level_exp *= exp_multiplier
	Ref.create_new_level_fx(global_position)
	EventBus.on_player_stats_updated.emit()

func setup() -> void:
	reset_health()
	reset_mana()
	next_level_exp = base_exp
	
	
func reset_health() -> void:
	health_component.setup(max_health)
	EventBus.on_player_health_updated.emit(max_health,max_health)

func reset_mana() -> void:
		curr_mana = max_mana
		EventBus.on_player_mana_updated.emit(max_mana,max_mana)

func use_mana(value: float) -> void:
	curr_mana = max(curr_mana-value,0)
	EventBus.on_player_mana_updated.emit(curr_mana,max_mana)
	

func add_mana(value: float) ->void:
	curr_mana += value
	curr_mana = max(curr_mana,max_mana)
	EventBus.on_player_mana_updated.emit(curr_mana,max_mana)


func enable_weapon_collision(value: bool) -> void:
	enemy_area.monitoring = value
	


func _on_skills_button_pressed() -> void:
	pass # Replace with function body.


func _on_health_component_on_dead() -> void:
	queue_free()


func _on_health_component_on_health_change(curr_health: float) -> void:
	EventBus.on_player_health_updated.emit(curr_health,max_health)


func _on_enemy_attack_area_area_entered(area: Area2D) -> void:
	var dmg = get_damage()
	area.health_component.take_damage(dmg)
	Ref.create_damage_fx(area.global_position)
	Ref.create_damage_text(area.global_position,dmg)
