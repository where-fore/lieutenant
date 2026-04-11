extends Node2D

var inventory_slots:Array[InventorySlot] = []

#this is magically referencing the item ids i want. be wary
var starting_inventory:Array[String] = [
	#"rock",
]

var inventory_slot_parent:GridContainer
func set_inventory_slot_parent(new_parent:GridContainer) -> void:
	inventory_slot_parent = new_parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimingEvents.everythings_ready.connect(on_scene_ready)
	InventoryEvents.clear_all_to_restart.connect(clear_inventory)
	InventoryEvents.rebuild_all_to_restart.connect(populate_starter_items)
	InventoryEvents.send_item_to_inventory.connect(equip_to_first_available_slot)
	InventoryEvents.slot_updated.connect(update_inventory_full_status)
	InventoryEvents.item_successfully_equipped.connect(interpret_new_item)
	InventoryEvents.item_successfully_unequipped.connect(interpret_removed_item)
	CombatEvents.combat_started.connect(on_combat_start)
	CombatEvents.combatant_turn_started.connect(on_turn_start)
	CombatEvents.combatant_finished_attack.connect(on_attack)
	CombatEvents.combatant_damaged.connect(on_damage_taken)
	CombatEvents.combatant_turn_ended.connect(on_turn_end)
	CombatEvents.combat_finished.connect(on_combat_end)

func on_scene_ready() -> void:
	find_inventory_slot_nodes()
	update_inventory_full_status()
	populate_starter_items()

func on_turn_start(source:Combatant) -> void:
	if source.is_the_player:
		for slot:InventorySlot in inventory_slots: 
			if slot.is_empty(): continue
			if slot.item_in_slot:
				slot.item_in_slot.on_turn_start(source)

func on_attack(source:Combatant, target:Combatant) -> void:
	if source.is_the_player:
		for slot:InventorySlot in inventory_slots: 
			if slot.is_empty(): continue
			if slot.item_in_slot:
				slot.item_in_slot.on_attack(source, target)

func on_damage_taken(source:Combatant, amount_taken:int) -> void:
	if source.is_the_player:
		for slot:InventorySlot in inventory_slots: 
			if slot.is_empty(): continue
			if slot.item_in_slot:
				slot.item_in_slot.on_damage_taken(source, amount_taken)

func on_turn_end(source:Combatant) -> void:
	if source.is_the_player:
		for slot:InventorySlot in inventory_slots: 
			if slot.is_empty(): continue
			if slot.item_in_slot:
				slot.item_in_slot.on_turn_end(source)

func on_combat_start(_combatants:Array[Combatant]) -> void:
	for slot:InventorySlot in inventory_slots:
		if not slot.is_empty():
			var restarted_aura:Aura = slot.item_in_slot.restart_custom_auras()
			if restarted_aura: AuraEvents.give_aura_to_player.emit(restarted_aura)
			
			slot.item_in_slot.on_combat_start()
			

func on_combat_end(_combatants:Array[Combatant]) -> void:
	for slot:InventorySlot in inventory_slots:
		if not slot.is_empty():
			slot.item_in_slot.on_combat_end()

func find_inventory_slot_nodes() -> void:
	var class_to_check_for:StringName = &"InventorySlot"
	var found_nodes:Array[Node] = inventory_slot_parent.find_children("*", class_to_check_for, false)
	for node:Node in found_nodes:
		inventory_slots.append(node as InventorySlot)
	if not found_nodes: push_error("inventory manager didn't find any inventory slots")

func find_first_empty_slot() -> InventorySlot:
	for slot:InventorySlot in inventory_slots:
		if slot.is_empty(): return slot
	#if we get this far, ie. iterated through all slots
	return null

func equip_to_first_available_slot(item_to_equip:Item) -> void:
	var slot_to_equip_to:InventorySlot = find_first_empty_slot()
	if slot_to_equip_to: slot_to_equip_to.equip_item(item_to_equip)
	else: push_error("actually tried to equip an item while inventory is full")
	update_inventory_full_status()

func clear_inventory() -> void:
	for slot:InventorySlot in inventory_slots:
		slot.unequip_item()

func populate_starter_items() -> void:
	for item_id:String in starting_inventory:
		if InventoryEvents.inventory_is_full:
			push_error("starting inventory tried to equip more items than slots available")
		
		equip_to_first_available_slot(Database.get_item_by_id(item_id))

func update_inventory_full_status() -> void:
	if find_first_empty_slot() == null: InventoryEvents.inventory_is_full = true
	else: InventoryEvents.inventory_is_full = false
	InventoryEvents.full_status_updated.emit()

func interpret_new_item(item:Item) -> void:
	var item_aura:Aura = item.get_aura()
	AuraEvents.give_aura_to_player.emit(item_aura)
	
	if item.applies_aura_on_equip():
		var item_custom_aura:Aura = item.get_custom_aura()
		if item_custom_aura:
			AuraEvents.give_aura_to_player.emit(item_custom_aura)

func interpret_removed_item(item:Item) -> void:
	var item_aura:Aura = item.get_aura()
	AuraEvents.remove_aura_from_player.emit(item_aura)
	
	var item_custom_aura:Aura = item.get_custom_aura()
	if item_custom_aura:
		AuraEvents.remove_aura_from_player.emit(item_custom_aura)
