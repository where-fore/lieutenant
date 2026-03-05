extends TextureButton
class_name InventorySlot

@export var item_in_slot: ItemData

@onready var slot_sprite: TextureRect = $ItemSprite

var tooltip_text_base: String = "Increases\nattack by "

@onready var delete_confirmation_panel: Control = $Panel
@onready var delete_confirmation_timer: Timer = $Timer
var delete_confirmation: bool = false
var delete_timer_current: float = 0
var delete_timer_max: float = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_sprite()
	delete_confirmation_panel.visible = false


func equip_item(item_to_equip: ItemData) -> void:
	item_in_slot = item_to_equip
	update_sprite()
	InventoryEvents.item_successfully_equipped.emit(item_to_equip)
	InventoryEvents.slot_updated.emit()
	tooltip_text = tooltip_text_base + str(item_in_slot.damage)

func unequip_item() -> void:
	#this is null if the slot was empty
	var old_item:ItemData = item_in_slot
	
	item_in_slot = null
	update_sprite()
	
	if old_item:
		InventoryEvents.item_successfully_unequipped.emit(old_item)
		InventoryEvents.slot_updated.emit()
	
	tooltip_text = ""


func is_empty() -> bool:
	return item_in_slot == null


func update_sprite() -> void:
	if item_in_slot: slot_sprite.texture = item_in_slot.item_sprite
	else: slot_sprite.texture = null


func _on_pressed() -> void:
	if not is_empty() and not CombatEvents.combat_ongoing:
		if not delete_confirmation:
			delete_confirmation_panel.visible = true
			delete_confirmation = true
			delete_confirmation_timer.start()
			
		elif delete_confirmation:
			delete_confirmation_panel.visible = false
			delete_confirmation = false
			unequip_item()
			delete_confirmation_timer.stop()


func _on_timer_timeout() -> void:
	delete_confirmation_panel.visible = false
	delete_confirmation = false
