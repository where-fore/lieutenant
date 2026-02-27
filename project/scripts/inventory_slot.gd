extends TextureRect
class_name InventorySlot

@export var item_in_slot: ItemData

@onready var slot_sprite = $"ItemSprite"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()


func equip_item(item_to_equip):
	item_in_slot = item_to_equip
	update_sprite()


func is_empty() -> bool:
	return item_in_slot == null


func update_sprite():
	if item_in_slot: slot_sprite.texture = item_in_slot.item_sprite
