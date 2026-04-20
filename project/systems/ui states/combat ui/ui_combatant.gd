extends VBoxContainer
class_name UiCombatant

@onready var sprite:TextureRect = $MarginContainer/Sprite
@onready var health_label:Label = $Stats/Health/HBoxContainer/Label
@onready var attack_label:Label = $Stats/Attack/HBoxContainer/Label
@onready var turn_indicator:TextureRect = $MarginContainer/Sprite/TurnIndicator
var my_combatant:Combatant

func _ready() -> void:
	HudEvents.combatant_turn_next.connect(hear_turn_ready)
	
	turn_indicator.visible = false
	visible = false

func assign_combatant(combatant:Combatant) -> void:
	my_combatant = combatant
	sprite.texture = my_combatant.combatant_texture
	my_combatant.stats_updated.connect(update_stats)
	update_stats()
	visible = true

func update_stats() -> void:
	health_label.text = str(my_combatant.get_damaged_health())
	attack_label.text = str(my_combatant.current_stats[Stats.attack])

func hear_turn_ready(source:Combatant) -> void:
	if source == my_combatant:
		turn_indicator.visible = true
	else:
		turn_indicator.visible = false

func force_show_turn_indicator() -> void:
	turn_indicator.visible = true

func force_hide_turn_indicator() -> void:
	turn_indicator.visible = false

func clear_combatant() -> void:
	if my_combatant:
		my_combatant.stats_updated.disconnect(update_stats)
		my_combatant = null
	sprite.texture = null
	health_label.text = ""
	attack_label.text = ""
	visible = false
