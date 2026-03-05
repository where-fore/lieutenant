extends ScrollContainer

@onready var label: Label = $MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_log()
	
	CombatEvents.attack_launched.connect(interpret_damage_dealt)
	HudEvents.change_to_combat_screen.connect(clear_log)


func clear_log() -> void:
	label.text = ""
	

func interpret_damage_dealt(source_object: Combatant, amount: int) -> void:
	var source_name: String = source_object.baseData.name
	var damage: String = str(amount)
	var text_to_add: String = source_name + " " + "deals" + " " + damage + " " + "damage."
	append_to_label(text_to_add)


func append_to_label(text_to_append: String) -> void:
	var linebreak: String = "\n"
	if label.text == "": label.text += text_to_append
	else:	label.text += linebreak + text_to_append
