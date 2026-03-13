extends ScrollContainer

@onready var label:Label = $MarginContainer/Label

#these probably should have a space at the start, and a period at the end
var death_messages:Array[String] = [
	 " falls to the worms.",
	 " crumbles to dust.",
	 " will now feed the vultures.",
	 " no longer stands in your way.",
	 " succumbs to your might.",
	]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_log()
	
	CombatEvents.attack_launched.connect(interpret_damage_dealt)
	CombatLogEvents.aura_removed.connect(report_aura_removed)
	CombatLogEvents.aura_applied.connect(report_aura_applied)
	HudEvents.change_to_combat_screen.connect(clear_log)
	CombatEvents.combatant_died.connect(report_death)
	CombatLogEvents.custom_message.connect(print_custom_message)


func clear_log() -> void:
	label.text = ""
	

func interpret_damage_dealt(source_object:Combatant, amount:int) -> void:
	var source_name:String = source_object.baseData.name
	var damage:String = str(amount)
	var text_to_add:String = source_name + " " + "deals" + " " + damage + " " + "damage."
	append_to_label(text_to_add)

func report_aura_removed(source:Combatant, aura:Aura) -> void:
	if source.is_the_player:
		var aura_name:String = aura.aura_name
		if not aura.aura_name:
			push_error("fading aura has no name supplied")
			push_error(aura.additive_dictionary)
		else:
			var text_to_add:String = aura_name + " fades from your spirit."
			append_to_label(text_to_add)

func report_aura_applied(aura:Aura) -> void:
	var aura_name:String = aura.aura_name
	var text_to_add:String = aura_name + " bolsters your spirit."
	append_to_label(text_to_add)

func report_death(newly_dead:Combatant) -> void:
	var character_name:String = newly_dead.baseData.name
	var text_to_add:String = character_name + death_messages.pick_random()
	append_to_label(text_to_add)

func print_custom_message(message:String) -> void:
	append_to_label(message)

func append_to_label(text_to_append:String) -> void:
	var linebreak:String = "\n"
	if label.text == "": label.text += text_to_append
	else: label.text += linebreak + text_to_append
