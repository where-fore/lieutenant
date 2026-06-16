extends ScrollContainer

@onready var label:RichTextLabel = $MarginContainer/Label
var linebreak:String = "\n"
var full_log_history:Array[String]
var short_log_history:Array[String]
var short_log_max_size:int = 100

#these probably should have a space at the start, and a period at the end
var death_messages:Array[String] = [
	 " falls to the worms.",
	 " crumbles to dust.",
	 " will now feed the vultures.",
	 " no longer stands in your way.",
	 " succumbs to your might.",
	]
var retreat_messages:Array[String] = [
	 " narrowly escapes a fatal blow.",
	 " breaks line and runs to the hills.",	
	]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_log()
	
	CombatEvents.attack_launched.connect(interpret_attack)
	CombatEvents.damage_applied.connect(interpret_damage_taken)
	CombatEvents.healing_applied.connect(interpret_healing)
	CombatLogEvents.shield_absorbed.connect(interpret_damage_shielded)
	CombatLogEvents.aura_removed.connect(report_aura_removed)
	CombatLogEvents.aura_applied.connect(report_aura_applied)
	CombatLogEvents.item_equipped.connect(report_item_equipped)
	CombatEvents.combatant_died.connect(report_death)
	CombatLogEvents.custom_message.connect(print_custom_message)
	HudEvents.chapter_lost.connect(clear_log)
	#HudEvents.chapter_won.connect(clear_log)
	#MapEvents.combat_all_done.connect(clear_log)
	MapEvents.enter_combat_in.connect(entering_combat)
	ScenarioEvents.begin_combat_with.connect(entering_combat)

func entering_combat(current_combat:Variant) -> void:
	clear_log()
	var current_enemies:Array[Combatant]
	if current_combat is Array[Combatant]:
		current_enemies = current_combat
	elif current_combat is MapTile:
		current_enemies = current_combat.tile_data.enemies
	else:
		push_error("got sent data type: ", type_string(typeof(current_combat)))
	
	new_combat_line(current_enemies)

func clear_log() -> void:
	label.text = ""
	short_log_history.clear()

func new_combat_line(combatants:Array[Combatant]) -> void:
	var names:Array[String]
	for enemy:Combatant in combatants:
		names.append(enemy.combatant_name)
	var enemies:String = ", ".join(names)
	
	var day:String = "Day " + str(TimeOfDay.current_day)
	var time:String = str(TimeOfDay.current_time_step * 4) + "h"
	var time_string:String = day + " " + time
	
	var to_append:String = ""
	to_append += "\n"
	to_append += " - The moon reads: " + time_string + " - "
	to_append += "\n"
	to_append += " -- Combat begins with foes: "
	to_append += enemies + " -- " #maybe colour these?
	to_append += "\n"
	append_to_label(to_append)

func interpret_attack(source_object:Combatant, _amount:int, target_object:Combatant) -> void:
	var source_name:String = source_object.combatant_name
	var target_name:String = target_object.combatant_name
	var attack_word_color:String = Color.ORANGE_RED.to_html()
	var attack_word_fancy:String = "[color=#%s]%s[/color]" % [attack_word_color, "attacks"]
	
	var text_to_add:String = source_name + " {attacks} " + target_name + "."
	text_to_add = text_to_add.format({"attacks": attack_word_fancy})
	
	append_to_label(text_to_add)

func interpret_damage_taken(source_object:Combatant, amount:int) -> void:
	var source_name:String = source_object.combatant_name
	var text_to_add:String = source_name + " suffers " + "{amount}" + " damage."
	
	var damage_color:String = Color.ORANGE_RED.to_html()
	var damage_fancy:String = "[color=#%s]%s[/color]" % [damage_color, str(amount)]
	text_to_add = text_to_add.format({"amount": damage_fancy})
	
	append_to_label(text_to_add)

func interpret_damage_shielded(source_object:Combatant, amount:int) -> void:
	var source_name:String = source_object.combatant_name
	var text_to_add:String = source_name + " shields " + "{amount}" + " damage."
	
	var damage_color:String = Color.DODGER_BLUE.to_html()
	var damage_fancy:String = "[color=#%s]%s[/color]" % [damage_color, str(amount)]
	text_to_add = text_to_add.format({"amount": damage_fancy})
	
	append_to_label(text_to_add)

func interpret_healing(source_object:Combatant, amount:int) -> void:
	var source_name:String = source_object.combatant_name
	var text_to_add:String = source_name + " heals " + "{amount}" + " health."
	
	var damage_color:String = Color.LAWN_GREEN.to_html()
	var damage_fancy:String = "[color=#%s]%s[/color]" % [damage_color, str(amount)]
	text_to_add = text_to_add.format({"amount": damage_fancy})
	
	append_to_label(text_to_add)

func report_aura_removed(aura:Aura, combatant:Combatant) -> void:
	if aura.visible:
		var reward_name:String = aura.reward_name #this is redundant, to null check
		if not aura.reward_name:
			push_error("fading aura has no name supplied")
			push_error(aura.additive_stat_dictionary) #hopefully helps narrow down what the aura was
		
		else:
			var aura_color:String = Color.GOLDENROD.to_html()
			var combatant_color:String = Color.MEDIUM_VIOLET_RED.to_html()
			
			var text_to_add:String = "The aura of {aura} loosens from {combatant}."
			
			var aura_fancy:String = "[color=#%s]%s[/color]" % [aura_color, aura.reward_name]
			var combatant_fancy:String = "[color=#%s]%s[/color]" % [combatant_color, combatant.combatant_name]
			text_to_add = text_to_add.format({"aura": aura_fancy, "combatant": combatant_fancy})
			
			append_to_label(text_to_add)

func report_aura_applied(aura:Aura, combatant:Combatant) -> void:
	var aura_color:String = Color.GOLDENROD.to_html()
	var combatant_color:String = Color.MEDIUM_VIOLET_RED.to_html()
	
	var text_to_add:String = "The aura of {aura} encircles {combatant}."
	
	var aura_fancy:String = "[color=#%s]%s[/color]" % [aura_color, aura.reward_name]
	var combatant_fancy:String = "[color=#%s]%s[/color]" % [combatant_color, combatant.combatant_name]
	text_to_add = text_to_add.format({"aura": aura_fancy, "combatant": combatant_fancy})
	
	append_to_label(text_to_add)

func report_item_equipped(item:Item, combatant:Combatant) -> void:
	var item_color:String = Color.GOLDENROD.to_html()
	var combatant_color:String = Color.MEDIUM_VIOLET_RED.to_html()
	
	var text_to_add:String = "{item} now wielded by the hands of {combatant}."
	
	var item_fancy:String = "[color=#%s]%s[/color]" % [item_color, item.reward_name]
	var combatant_fancy:String = "[color=#%s]%s[/color]" % [combatant_color, combatant.combatant_name]
	text_to_add = text_to_add.format({"item": item_fancy, "combatant": combatant_fancy})
	
	append_to_label(text_to_add)

func report_death(newly_dead:Combatant) -> void:
	var character_name:String
	var text_to_add:String
	
	character_name = newly_dead.combatant_name
	
	if newly_dead.is_an_enemy:
		text_to_add = character_name + death_messages.pick_random()
	elif newly_dead.is_a_player:
		text_to_add = character_name + retreat_messages.pick_random()
	else:
		push_error("dead combatant is neither an enemy or the player, according to the event log")
	append_to_label(text_to_add)

func print_custom_message(message:String) -> void:
	append_to_label(message)

func show_full_log() -> void:
	create_text_paragraph(full_log_history)
	_scroll_to_the_bottom()

func append_to_label(text_to_append:String) -> void:
	full_log_history.append(text_to_append)
	short_log_history.append(text_to_append)
	
	while short_log_history.size() > short_log_max_size:
		short_log_history.remove_at(0)
	
	create_text_paragraph(short_log_history)
	
	_scroll_to_the_bottom()

func _scroll_to_the_bottom() -> void:
	await get_tree().process_frame
	var scrollbar:VScrollBar = get_v_scroll_bar()
	scrollbar.value = scrollbar.max_value

func create_text_paragraph(text_array:Array[String]) -> void:
	var starter:String = linebreak + " "
	label.text = starter.join(text_array)
