extends Control

var tracked_combatants:Array[Combatant]

@onready var info_panel_container:Control = $InfoContainer
@onready var edit_info_panel:InfoPanel = $InfoContainer/InfoPanel
var info_panels:Dictionary[Combatant, InfoPanel]
@export var info_panel_scene:PackedScene

@onready var tab_container:Control = $TabContainer/HBoxContainer
var empty_tabs:Array[StatTab]
var tabs:Dictionary[Combatant, StatTab]


func _ready() -> void:
	HudEvents.send_player_combatant_to_ui.connect(add_combatant_to_tracking)
	HudEvents.reward_added.connect(add_to_stat_panels)
	HudEvents.reward_removed.connect(remove_from_stat_panels)
	populate_tabs()
	edit_info_panel.queue_free()

func add_combatant_to_tracking(new_combatant:Combatant) -> void:
	if tabs.size() >= BalanceData.max_party_size:
		push_error("tried to track a new player combatant stats when already at max party size. attempted new combatant: ", new_combatant.combatant_name)
	else:
		add_new_info_panel(new_combatant)
		add_new_tab(new_combatant)

func remove_combatant_from_tracking(old_combatant:Combatant) -> void:
	remove_tab(old_combatant)
	remove_info_panel(old_combatant)

func add_new_tab(new_combatant:Combatant) -> void:
	if not tabs.has(new_combatant):
		var new_tab:StatTab = empty_tabs.pop_front()
		tabs[new_combatant] = new_tab
		
		new_tab.setup_from_combatant(new_combatant)
		new_tab.set_info_panel(info_panels.get(new_combatant))
		new_tab.tab_pressed.connect(swap_to_info_panel)
		
		new_tab.visible = true
		
	else:
		push_error("tried to overwrite ui tab containing: ", new_combatant.combatant_name)

func add_new_info_panel(new_combatant:Combatant) -> void:
	if not info_panels.has(new_combatant):
		var new_info_panel:InfoPanel = info_panel_scene.instantiate()
		info_panel_container.add_child(new_info_panel)
		new_info_panel.position = Vector2.ZERO
		
		new_info_panel.my_combatant = new_combatant
		info_panels[new_combatant] = new_info_panel
		
		new_info_panel.connect_signals()
		new_info_panel.update_title_stats()
		
		for item:Item in new_combatant.get_all_items():
			new_info_panel.my_item_panel.add_stat(item)
		for aura:Aura in new_combatant.get_all_auras():
			if aura.visible:
				new_info_panel.my_aura_panel.add_stat(aura)
		
	else:
		push_error("tried to overwrite stat info tab containing: ", new_combatant.combatant_name)

func remove_tab(old_combatant:Combatant) -> void:
	var old_tab:StatTab = tabs.get(old_combatant)
	tabs.erase(old_combatant)
	old_tab.clear_data()
	empty_tabs.append(old_tab)

func remove_info_panel(old_combatant:Combatant) -> void:
	var old_panel:InfoPanel = info_panels.get(old_combatant)
	old_panel.queue_free()
	info_panels.erase(old_combatant)

func populate_stat_panels() -> void:
	pass

func add_to_stat_panels(combatant:Combatant, new_reward:Reward) -> void:
	if new_reward is Item:
		info_panels[combatant].my_item_panel.add_stat(new_reward)
	elif new_reward is Aura:
		if new_reward.visible:
			info_panels[combatant].my_aura_panel.add_stat(new_reward)

func remove_from_stat_panels(combatant:Combatant, old_reward:Reward) -> void:
	if old_reward is Item:
		info_panels[combatant].my_item_panel.remove_stat(old_reward)
	elif old_reward is Aura:
		if old_reward.visible:
			info_panels[combatant].my_aura_panel.remove_stat(old_reward)

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
	tab.tab_pressed.connect(swap_to_party_panel)
	
	#hide until i implement the party wide auras
	tab.visible = false

func swap_to_info_panel(tab_pressed:StatTab) -> void:
	for panel:InfoPanel in info_panels.values():
		panel.visible = false
	tab_pressed.my_info_panel.visible = true

func swap_to_party_panel(_unused_arg:Variant) -> void:
	for panel:InfoPanel in info_panels.values():
		panel.visible = false
	
