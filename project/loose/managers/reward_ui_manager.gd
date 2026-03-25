extends Control

@export var reward_empty_texture:Texture2D

@onready var reward_button:TextureButton = $VBoxContainer/RewardButtons/RewardButton/VBoxContainer/TextureButton
@onready var reward_button_container:MarginContainer = $VBoxContainer/RewardButtons/RewardButton
@onready var reward_button_label:Label = $VBoxContainer/RewardButtons/RewardButton/VBoxContainer/Label

@onready var skip_button_container:MarginContainer = $VBoxContainer/SkipRewardButton

var reward_text_blurb:String = "The spoils of war"

var current_reward:Variant


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryEvents.full_status_updated.connect(update_inventory_full_indicator)
	MapEvents.enter_without_combat_in.connect(prepare_reward)
	MapEvents.enter_combat_in.connect(prepare_reward)

func change_to() -> void:
	visible = true

func change_from() -> void:
	clear_reward()
	visible = false

func prepare_reward(map_tile:MapTile) -> void:
	if map_tile.tile_data.aura_reward:
		current_reward = map_tile.tile_data.aura_reward.duplicate() as Aura
		reward_button.tooltip_text = current_reward.get_tooltip()
		reward_button.texture_normal = current_reward.aura_sprite
	
	elif map_tile.tile_data.item_reward:
		current_reward = map_tile.tile_data.item_reward.duplicate() as Item
		reward_button.tooltip_text = current_reward.get_tooltip()
		reward_button.texture_normal = current_reward.item_sprite
	
	if not current_reward:
		reward_button.texture_normal = reward_empty_texture
		reward_button.tooltip_text = "Continue..."
		reward_button_label.text = "Found nothing..."
	else:
		if current_reward is Aura:
			reward_button_label.text = reward_text_blurb
			reward_button.texture_normal = current_reward.aura_sprite
			reward_button.tooltip_text = current_reward.get_tooltip()
		
		elif current_reward is Item:
			reward_button_label.text = reward_text_blurb
			reward_button.texture_normal = current_reward.item_sprite
			reward_button.tooltip_text = current_reward.get_tooltip()
			
	update_inventory_full_indicator()

func update_inventory_full_indicator() -> void:
	reward_button.modulate = Color(1,1,1)
	reward_button_label.text = reward_text_blurb
	if current_reward is Item:
		if InventoryEvents.inventory_is_full:
			reward_button.modulate = Color(0.3,0.3,0.3)
			reward_button_label.text = "Inventory Full"

func _on_reward_button_pressed() -> void:
	if current_reward is Aura:
		AuraEvents.give_aura_to_player.emit(current_reward)
	elif current_reward is Item:
		InventoryEvents.send_item_to_inventory.emit(current_reward)
	reward_selected()

func _on_skip_button_pressed() -> void:
	reward_selected()

func reward_selected() -> void:
	HudEvents.reward_chosen.emit()

func clear_reward() -> void:
	reward_button_label.text = ""
	reward_button.texture_normal = reward_empty_texture
	reward_button.tooltip_text = ""
	
	current_reward = null
