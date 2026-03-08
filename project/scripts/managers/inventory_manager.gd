extends GridContainer

var inventory_slots : Array[Node] = []

@export var starting_items: Array[Item]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if starting_items.has(null): push_error("starting items has a null slot")
	
	find_inventory_slot_nodes()
	TimingEvents.everythings_ready.connect(on_scene_ready)
	InventoryEvents.clear_all_to_restart.connect(clear_inventory)
	InventoryEvents.rebuild_all_to_restart.connect(populate_starter_items)
	InventoryEvents.send_item_to_inventory.connect(equip)
	InventoryEvents.slot_updated.connect(update_inventory_full_status)
	InventoryEvents.item_successfully_equipped.connect(interpret_new_item)
	InventoryEvents.item_successfully_unequipped.connect(interpret_removed_item)
	CombatEvents.combat_started.connect(on_combat_start)
	CombatEvents.combat_finished.connect(on_combat_end)
	#this is unreadable programmer shorthand for "throw away all arguments but the one i care about, "attacker"
	@warning_ignore("untyped_declaration")
	CombatEvents.attack_launched.connect(func(attacker:Combatant, _other_arg): on_attack(attacker))

func on_scene_ready() -> void:
	populate_starter_items()

func on_attack(source: Combatant) -> void:
	if source.is_the_player():
		for slot: InventorySlot in inventory_slots: 
			if slot.is_empty(): continue
			if slot.item_in_slot:
				slot.item_in_slot.on_attack(source)

func on_combat_start(_combatants:Array[Combatant]) -> void:
	for slot: InventorySlot in inventory_slots:
		if not slot.is_empty():
			var restarted_aura:Aura = slot.item_in_slot.restart_custom_auras()
			if restarted_aura: StatEvents.give_aura_to_player.emit(restarted_aura)
			
			slot.item_in_slot.on_combat_start()
			

func on_combat_end() -> void:
	for slot: InventorySlot in inventory_slots:
		if not slot.is_empty():
			slot.item_in_slot.on_combat_end()

func find_inventory_slot_nodes() -> void:
	var class_to_check_for: StringName = &"InventorySlot"
	var found_nodes: Array[Node] = self.find_children("*", class_to_check_for, false)
	for node: Node in found_nodes:
		inventory_slots.append(node as InventorySlot)

#returns an InventorySlot class if it finds one empty, or null if none available
func find_first_empty_slot() -> InventorySlot:
	for slot: InventorySlot in inventory_slots:
		if slot.is_empty(): return slot
	#if we get this far, ie. iterated through all slots
	return null

func equip(item_to_equip:Item) -> void:
	var slot_to_equip_to: InventorySlot = find_first_empty_slot()
	if slot_to_equip_to: slot_to_equip_to.equip_item(item_to_equip)
	else: pass #print_debug("inventory full")
	update_inventory_full_status()

func clear_inventory() -> void:
	for slot:InventorySlot in inventory_slots:
		slot.unequip_item()

func populate_starter_items() -> void:
	for item: Item in starting_items:
		equip(item)

func update_inventory_full_status() -> void:
	if find_first_empty_slot() == null: InventoryEvents.inventory_is_full = true
	else: InventoryEvents.inventory_is_full = false
	InventoryEvents.full_status_updated.emit()


func interpret_new_item(item:Item) -> void:
	var item_aura:Aura = item.get_aura()
	StatEvents.give_aura_to_player.emit(item_aura)
	
	if item.applies_aura_on_equip():
		var item_custom_aura:Aura = item.get_custom_aura()
		if item_custom_aura:
			StatEvents.give_aura_to_player.emit(item_custom_aura)

func interpret_removed_item(item:Item) -> void:
	var item_aura:Aura = item.get_aura()
	StatEvents.remove_aura_from_player.emit(item_aura)
	
	var item_custom_aura:Aura = item.get_custom_aura()
	if item_custom_aura:
		StatEvents.remove_aura_from_player.emit(item_custom_aura)
