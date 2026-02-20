extends ScrollContainer

@onready var label = $MarginContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_log()
	
	CombatEvents.attack_launched.connect(interpret_damage_dealt)
	HudEvents.change_to_combat_screen.connect(clear_log)


func clear_log():
	label.text = ""
	

func interpret_damage_dealt(source_object, amount):
	var source_name = source_object.name
	amount = str(amount)
	var text_to_add = source_name + " " + "deals" + " " + amount + " " + "damage."
	append_to_label(text_to_add)


func append_to_label(text_to_append):
	var linebreak = "\n"
	if label.text == "": label.text += text_to_append
	else:	label.text += linebreak + text_to_append
