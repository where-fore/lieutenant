extends GridContainer

var inventory_slots : Array[Node] = []

@export var starting_items: Array[ItemData]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_inventory_slots()
	populate_starter_items()
	
	#on combat lost, clear inventory
	HudEvents.combat_lost.connect(perish)

	#science be here
	
	#await get_tree().create_timer(5).timeout
	#equip(starting_items[0])
	
	#science be over


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func find_inventory_slots():
	var class_to_check_for = "InventorySlot"
	var found_nodes = self.find_children("*", class_to_check_for, false)
	for node in found_nodes:
		inventory_slots.append(node as InventorySlot)


#returns an InventorySlot class if it finds one empty, or null if none available
func find_first_empty_slot():
	for slot: InventorySlot in inventory_slots:
		if slot.is_empty(): return slot
	#if we get this far, ie. iterated through all slots
	return null


func equip(item_to_equip:ItemData):
	var slot_to_equip_to: InventorySlot = find_first_empty_slot()
	if slot_to_equip_to: slot_to_equip_to.equip_item(item_to_equip)
	else: print_debug("inventory full")


func perish():
	clear_inventory()
	populate_starter_items()
	


func clear_inventory():
	for slot:InventorySlot in inventory_slots:
		slot.unequip_item()


func populate_starter_items():
	for item in starting_items:
		equip(item)
