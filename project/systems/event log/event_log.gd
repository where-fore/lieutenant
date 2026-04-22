extends ScrollContainer

@onready var label:RichTextLabel = $MarginContainer/Label

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
	CombatLogEvents.aura_removed.connect(report_aura_removed)
	CombatLogEvents.aura_applied.connect(report_aura_applied)
	HudEvents.change_to_combat_screen.connect(clear_log)
	MapEvents.combat_all_done.connect(clear_log)
	CombatEvents.combatant_died.connect(report_death)
	CombatLogEvents.custom_message.connect(print_custom_message)
	HudEvents.chapter_lost.connect(clear_log)
	HudEvents.chapter_won.connect(clear_log)


func clear_log() -> void:
	label.text = ""
	

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
			
			var text_to_add:String = "{aura} bolsters the spirit of {combatant}."
			
			var aura_fancy:String = "[color=#%s]%s[/color]" % [aura_color, aura.reward_name]
			var combatant_fancy:String = "[color=#%s]%s[/color]" % [combatant_color, combatant.combatant_name]
			text_to_add = text_to_add.format({"aura": aura_fancy, "combatant": combatant_fancy})
			
			append_to_label(text_to_add)

func report_aura_applied(aura:Aura, combatant:Combatant) -> void:
	var aura_color:String = Color.GOLDENROD.to_html()
	var combatant_color:String = Color.MEDIUM_VIOLET_RED.to_html()
	
	var text_to_add:String = "{aura} bolsters the spirit of {combatant}."
	
	var aura_fancy:String = "[color=#%s]%s[/color]" % [aura_color, aura.reward_name]
	var combatant_fancy:String = "[color=#%s]%s[/color]" % [combatant_color, combatant.combatant_name]
	text_to_add = text_to_add.format({"aura": aura_fancy, "combatant": combatant_fancy})
	
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

func append_to_label(text_to_append:String) -> void:
	text_to_append = " " + text_to_append
	var linebreak:String = "\n"
	if label.text == "": label.text += text_to_append
	else: label.text += linebreak + text_to_append
