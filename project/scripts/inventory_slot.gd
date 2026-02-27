extends TextureRect
class_name InventorySlot

@export var item_in_slot: ItemData

@onready var slot_sprite = $"Inventory Item"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if item_in_slot:
		slot_sprite.texture = item_in_slot.item_sprite

func add_test_item(item_to_test_with):
	item_in_slot = item_to_test_with
