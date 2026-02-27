extends GridContainer

var inventory_slots : Array[Node] = []

@export var test_item:ItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_inventory_slots()
	#equip(test_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func find_inventory_slots():
	var class_to_check_for = "InventorySlot"
	var found_nodes = self.find_children("*", class_to_check_for, false)
	for node in found_nodes:
		inventory_slots.append(node as InventorySlot)


#returns an InventorySlot class if it finds one, or null if none.
func find_first_empty_slot():
	for slot: InventorySlot in inventory_slots:
		if slot.is_empty(): return slot
	#if we get this far, ie. iterated through all slots
	return null

func equip(item_to_equip:ItemData):
	var slot_to_equip_to = find_first_empty_slot()
	if slot_to_equip_to: slot_to_equip_to.equip(item_to_equip)
	else: print_debug("inventory full")
