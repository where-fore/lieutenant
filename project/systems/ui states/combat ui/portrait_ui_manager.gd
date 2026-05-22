extends Control

@onready var edit_border:TextureRect = $EditBorder

@export var player_ui_combatant_container:Control
var player_ui_combatants:Array[UiCombatant]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.send_player_combatant_to_ui.connect(assign_player_to_ui)
	HudEvents.load_portrait_ui.connect(change_to)
	HudEvents.unload_portrait_ui.connect(change_from)
	TimingEvents.everythings_ready.connect(on_scene_ready)
	
	edit_border.visible = false
	
	populate_ui_combatants()

func on_scene_ready() -> void:
	pass

func populate_ui_combatants() -> void:
	for child:Node in player_ui_combatant_container.get_children():
		if child is UiCombatant:
			player_ui_combatants.append(child)
	if player_ui_combatants.size() != BalanceData.max_party_size:
		push_error("portait ui size not matching balance data party size. found ", player_ui_combatants.size(), " ui combatants. found ", BalanceData.max_party_size, " as max party size")
	#could also have this instantiate ui combatants to match party size.. but i sorta like being able to edit them in 2d space, to see the look

func assign_player_to_ui(player:Combatant) -> void:
	var assigned:bool = false
	for uiCombatant:UiCombatant in player_ui_combatants:
		if not uiCombatant.my_combatant:
			uiCombatant.assign_combatant(player)
			uiCombatant.show_actives()
			assigned = true
			return #breaks the for loop, ie. stopping at this uicombatant
	
	if not assigned:
		push_error("was given a new player combatant but already had all ui combatants filled. tried to add: ", player.combatant_name, ". already had the following combatants: ") 
		for uiCombatant:UiCombatant in player_ui_combatants:
			if uiCombatant.my_combatant:
				push_error(uiCombatant.my_combatant.combatant_name)
			else:
				push_error("somehow did not assign the new player, but also had a ui combatant with a null combatant reference?")

func change_to() -> void:
	visible = true

func change_from() -> void:
	visible = false
