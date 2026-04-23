extends Node2D
class_name ItemManager

var parent_combatant:Combatant

#this is magically referencing the item ids i want. be wary
var starting_inventory:Array[String] = [
	#"rock",
]

var inventory:Array[Item]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_combatant = get_parent() as Combatant
	populate_starter_items()

func clear_inventory() -> void:
	for item:Item in inventory:
		item.unequip_item()

func populate_starter_items() -> void:
	for item_id:String in starting_inventory:
		equip_item(Database.get_item_by_id(item_id))

func equip_item(new_item:Item) -> void:
	interpret_new_item(new_item)

func unequip_item(new_item:Item) -> void:
	interpret_removed_item(new_item)

func interpret_new_item(item:Item) -> void:
	var item_aura:Aura = item.get_aura()
	parent_combatant.apply_aura_or_item(item_aura)
	
	if item.applies_aura_on_equip():
		var item_custom_aura:Aura = item.get_custom_aura()
		if item_custom_aura:
			parent_combatant.apply_aura_or_item(item_custom_aura)

func interpret_removed_item(item:Item) -> void:
	var item_aura:Aura = item.get_aura()
	parent_combatant.remove_aura_or_item(item_aura)
	
	var item_custom_aura:Aura = item.get_custom_aura()
	if item_custom_aura:
		parent_combatant.remove_aura_or_item(item_custom_aura)

func on_start_combat() -> void:
	for item:Item in inventory:
		var restarted_aura:Aura = item.restart_custom_auras()
		if restarted_aura: AuraEvents.give_aura_to_player.emit(restarted_aura)
		item.on_combat_start()

func on_start_turn() -> void:
	for item:Item in inventory:
		item.on_turn_start(parent_combatant)

func on_after_attack(target:Combatant) -> void:
	for item:Item in inventory:
		item.on_attack(parent_combatant, target)

func on_damage_taken(amount_taken:int) -> void:
	for item:Item in inventory:
		item.on_damage_taken(parent_combatant, amount_taken)

func on_end_turn() -> void:
	for item:Item in inventory:
		item.on_turn_end(parent_combatant)

func on_combat_end() -> void:
	for item:Item in inventory:
		item.on_combat_end()
