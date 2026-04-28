extends Control

var tracked_combatants:Array[Combatant]

@onready var tab_container:Control = $VBoxContainer/Tabs/HBoxContainer
var empty_tabs:Array[StatTab]
var tabs:Dictionary[Combatant, StatTab]

func _ready() -> void:
	HudEvents.send_player_combatant_to_ui.connect(add_combatant_to_tracking)
	populate_tabs()

func add_combatant_to_tracking(new_combatant:Combatant) -> void:
	if tabs.size() >= BalanceData.max_party_size:
		push_error("tried to track a new player combatant stats when already at max party size. attempted new combatant: ", new_combatant.combatant_name)
	else:
		if not tabs.has(new_combatant):
			tabs[new_combatant] = empty_tabs.pop_front()
		else:
			push_error("tried to overwrite ui tab containing: ", new_combatant.combatant_name)

func remove_combatant_from_tracking(old_combatant:Combatant) -> void:
	tabs.erase(old_combatant)
	#could do a array.find() and check that index, for error checking and etc since erase silently fails
	#but i like this, it's what i do elsewhere

func populate_tabs() -> void:
	for child:Node in tab_container.get_children():
		if child is StatTab:
			empty_tabs.append(child)
	if empty_tabs.size() - 1 != BalanceData.max_party_size: # -1 for the "party" tab
		push_error("stats ui tab size not matching balance data party size. found ", empty_tabs.size() - 1, " non-party tabs. found ", BalanceData.max_party_size, " as max party size")
	
	set_party_tab(empty_tabs[0])
	for tab:StatTab in empty_tabs:
		tab.visible = false

func set_party_tab(tab:StatTab) -> void:
	empty_tabs.erase(tab)
	tab.set_label("Party")
	tab.set_portrait(load("res://sprites/player.png"))
