extends CanvasLayer

var attack_per_upgrade = 2
var health_per_upgrade = 20

@export var attack_upgrade_item: WeaponData

@onready var item_reward_button_parent = $Control/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not attack_upgrade_item:
		push_error("Critical Error: no attack reward item assigned")
		return
	InventoryEvents.full_status_updated.connect(update_item_reward_availability)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func change_to():
	update_item_reward_availability()
	visible = true

func change_from():
	visible = false

func update_item_reward_availability():
	if InventoryEvents.inventory_is_full:
		item_reward_button_parent.modulate = Color(0.3,0.3,0.3)
	else:
		item_reward_button_parent.modulate = Color(1,1,1)


func _on_sword_sprite_pressed() -> void:
	InventoryEvents.send_item_to_inventory.emit(attack_upgrade_item)
	reward_selected()

func _on_heart_sprite_pressed() -> void:
	StatEvents.health_increased.emit(health_per_upgrade)
	reward_selected()

func reward_selected():
	HudEvents.reward_chosen.emit()
	
