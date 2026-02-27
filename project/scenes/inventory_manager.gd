extends GridContainer

var inventory_slots : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_inventory_slots()
	for slot in inventory_slots:
		slot.add_test_item()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func find_inventory_slots():
	var class_to_check_for = "InventorySlot"
	var found_nodes = self.find_children("*", class_to_check_for, false)
	for node in found_nodes:
		inventory_slots.append(node as InventorySlot)
	
