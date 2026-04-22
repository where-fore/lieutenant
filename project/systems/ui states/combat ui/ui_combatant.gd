extends VBoxContainer
class_name UiCombatant

@onready var sprite:TextureRect = $Portrait/Portrait
@onready var health_bar:TextureProgressBar = $Portrait/HealthBarBorder/HealthBar
@onready var turn_indicator:TextureRect = $Portrait/Portrait/TurnIndicator
@onready var active_button_container:Control = $Portrait/Actives
var my_combatant:Combatant

func _ready() -> void:
	HudEvents.combatant_turn_next.connect(hear_turn_ready)
	
	turn_indicator.visible = false
	visible = false
	active_button_container.visible = false

func assign_combatant(combatant:Combatant) -> void:
	my_combatant = combatant
	sprite.texture = my_combatant.combatant_texture
	my_combatant.stats_updated.connect(update_stats)
	my_combatant.perished.connect(perish)
	update_stats()
	visible = true

func show_actives() -> void:
	active_button_container.visible = true

func update_stats() -> void:
	health_bar.max_value = my_combatant.current_stats[Stats.health]
	health_bar.value = my_combatant.get_damaged_health()
	health_bar.tooltip_text = str(int(health_bar.value))

func perish() -> void:
	self.modulate = Color(0.6, 0.3, 0.3)

func unperish() -> void:
	self.modulate = Color(1, 1, 1)

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
		my_combatant.perished.disconnect(perish)
		my_combatant = null
	sprite.texture = null
	visible = false
	unperish()
