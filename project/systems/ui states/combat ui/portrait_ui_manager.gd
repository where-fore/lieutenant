extends Control

@onready var edit_border:TextureRect = $EditBorder

@onready var player1_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player1
@onready var player2_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player2
@onready var player3_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player3
@onready var player4_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player4

var player_ui_combatants:Array[UiCombatant]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.send_player_combatants_to_ui.connect(assign_player_to_ui)
	HudEvents.load_portrait_ui.connect(change_to)
	HudEvents.unload_portrait_ui.connect(change_from)
	TimingEvents.everythings_ready.connect(on_scene_ready)
	
	edit_border.visible = false
	
	player_ui_combatants = [player1_ui_combatant, player2_ui_combatant, player3_ui_combatant, player4_ui_combatant]

func on_scene_ready() -> void:
	pass

func assign_player_to_ui(player:Combatant) -> void:
	for uiCombatant:UiCombatant in player_ui_combatants:
		if not uiCombatant.my_combatant:
			uiCombatant.assign_combatant(player)
			uiCombatant.show_actives()
			return #breaks the for loop

func change_to() -> void:
	visible = true

func change_from() -> void:
	visible = false
