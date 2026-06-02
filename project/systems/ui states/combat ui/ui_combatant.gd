extends VBoxContainer
class_name UiCombatant

@export var portrait:TextureRect
@export var health_bar:TextureProgressBar
@export var shield_bar:TextureProgressBar
@export var turn_indicator:TextureRect
@export var placeholder_attack:Control
@export var main_tooltip_control:Control
var my_combatant:Combatant

func _ready() -> void:
	HudEvents.combatant_turn_next.connect(hear_turn_ready)
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	CombatEvents.combat_finished.connect(func(_unused_data) -> void: force_hide_turn_indicator())
	
	turn_indicator.visible = false
	visible = false
	
	shield_bar.visible = false

func assign_combatant(combatant:Combatant) -> void:
	my_combatant = combatant
	portrait.texture = my_combatant.combatant_texture
	my_combatant.stats_updated.connect(update_stats)
	my_combatant.perished.connect(perish)
	my_combatant.revived.connect(unperish)
	update_stats()
	visible = true

func update_stats() -> void:
	placeholder_attack.tooltip_text = str(my_combatant.current_stats[Stats.attack])
	
	health_bar.max_value = my_combatant.current_stats[Stats.health]
	health_bar.value = my_combatant.get_damaged_health()
	health_bar.tooltip_text = str(int(health_bar.value))
	
	if my_combatant.shield > 0:
		shield_bar.max_value = my_combatant.current_stats[Stats.health]
		shield_bar.value = my_combatant.shield
		
		health_bar.tooltip_text += " + " + str(my_combatant.shield)
		shield_bar.visible = true
		
	elif my_combatant.shield <= 0:
		shield_bar.visible = false
	
	main_tooltip_control.tooltip_text = my_combatant.get_tooltip()
	hacky_tooltip_refresh()

func hacky_tooltip_refresh() -> void:
	#cringe
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()
	
	get_viewport().warp_mouse(mouse_pos + Vector2.ONE)
	get_viewport().warp_mouse(mouse_pos)

func perish() -> void:
	self.modulate = Color(0.6, 0.3, 0.3)

func unperish() -> void:
	self.modulate = Color(1, 1, 1)

func hear_turn_ready(source:Combatant) -> void:
	if source == my_combatant:
		force_show_turn_indicator()
	else:
		force_hide_turn_indicator()

func force_show_turn_indicator() -> void:
	turn_indicator.visible = true

func force_hide_turn_indicator() -> void:
	turn_indicator.visible = false

func force_show_selection_indicator() -> void:
	force_show_turn_indicator()

func force_hide_selection_indicator() -> void:
	force_hide_turn_indicator()

func clear_combatant() -> void:
	if my_combatant:
		my_combatant.stats_updated.disconnect(update_stats)
		my_combatant.perished.disconnect(perish)
		my_combatant.revived.disconnect(unperish)
		my_combatant = null
	portrait.texture = null
	visible = false
	unperish()


func _on_portrait_mouse_entered() -> void:
	if CursorManager.hovering_reward:
		force_show_selection_indicator()

func _on_portrait_mouse_exited() -> void:
	if CursorManager.hovering_reward:
		force_hide_selection_indicator()

func apply_reward(reward:Reward) -> void:
	my_combatant.apply_aura_or_item(reward)
	force_hide_selection_indicator()

func _on_portrait_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if CursorManager.hovering_reward:
				apply_reward(CursorManager.hovering_reward)
				CursorManager.take_hovered_reward()
			#else open character sheet?
