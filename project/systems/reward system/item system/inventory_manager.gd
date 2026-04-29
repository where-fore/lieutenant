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
	if parent_combatant.is_a_player: HudEvents.reward_added.emit(parent_combatant, new_item)

func unequip_item(old_item:Item) -> void:
	interpret_removed_item(old_item)
	if parent_combatant.is_a_player: HudEvents.reward_removed.emit(parent_combatant, old_item)

func interpret_new_item(item:Item) -> void:
	inventory.append(item)
	
	var item_aura:Aura = item.get_aura()
	parent_combatant.apply_aura_or_item(item_aura)

	var item_custom_auras:Array[Aura] = item.get_custom_auras()
	if item_custom_auras:
		for aura:Aura in item_custom_auras:
			parent_combatant.apply_aura_or_item(aura)
	
	item.custom_aura_added.connect(parent_combatant.apply_aura_or_item)
	item.custom_aura_removed.connect(parent_combatant.remove_aura_or_item)

func interpret_removed_item(item:Item) -> void:
	inventory.erase(item)
	
	var item_aura:Aura = item.get_aura()
	parent_combatant.remove_aura_or_item(item_aura)
	
	var item_custom_auras:Array[Aura] = item.get_custom_auras()
	if item_custom_auras:
		for aura:Aura in item_custom_auras:
			parent_combatant.remove_aura_or_item(aura)
	
	item.custom_aura_added.disconnect(parent_combatant.apply_aura_or_item)
	item.custom_aura_removed.disconnect(parent_combatant.remove_aura_or_item)

func on_start_combat() -> void:
	for item:Item in inventory:
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
