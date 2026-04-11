extends Control

@export var reward_empty_texture:Texture2D

@onready var reward_button:TextureButton = $VBoxContainer/RewardButtons/RewardButton/VBoxContainer/TextureButton
@onready var reward_button_container:MarginContainer = $VBoxContainer/RewardButtons/RewardButton
@onready var reward_button_label:Label = $VBoxContainer/RewardButtons/RewardButton/VBoxContainer/Label
@onready var title_text_label:Label = $VBoxContainer/Title/Title
@onready var skip_button_container:MarginContainer = $SkipRewardButton

var basic_title_text_blurb:String = "Victory.\nClaim your boon."
var current_title_text_blurb:String
var basic_reward_text_blurb:String = "The spoils of war"
var current_reward_text_blurb:String

var current_reward:Variant
var current_map_tile:MapTile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryEvents.full_status_updated.connect(update_text_blurb_and_inventory_full_indicator)
	MapEvents.venture_to.connect(prepare_from_map_tile)
	ScenarioEvents.setup_reward.connect(prepare_from_scenario)

func change_to() -> void:
	if current_map_tile:
		if current_map_tile.end_of_chapter:
			HudEvents.chapter_won.emit()
			return #closes this whole function
	
	if current_reward:
		visible = true
	else:
		print_debug("skipping rewards, since none was prepped")
		all_done()

func change_from() -> void:
	clear_reward()
	visible = false

func prepare_from_map_tile(map_tile:MapTile) -> void:
	current_map_tile = map_tile
	
	if current_map_tile.end_of_chapter:
		pass
	else:
		if current_map_tile.tile_data.aura_reward:
			current_reward = current_map_tile.tile_data.aura_reward as Aura
		elif current_map_tile.tile_data.item_reward:
			current_reward = current_map_tile.tile_data.item_reward as Item
		prepare_reward()

func prepare_from_scenario(reward:Variant) -> void:
	if (not reward is Item) and (not reward is Aura):
		push_error("tried to prepare reward from scenario, but was given class: " + reward.get_class())
	current_reward = reward
	prepare_reward()

func prepare_reward() -> void:
	if current_reward is Aura:
		reward_button.texture_normal = current_reward.aura_sprite
		reward_button.tooltip_text = current_reward.get_tooltip()
	elif current_reward is Item:
		reward_button.texture_normal = current_reward.item_sprite
		reward_button.tooltip_text = current_reward.get_tooltip()
	elif not current_reward:
		current_reward_text_blurb = "Found nothing..."
		reward_button.texture_normal = reward_empty_texture
		reward_button.tooltip_text = "Continue..."
	
	update_text_blurb_and_inventory_full_indicator()

func update_text_blurb_and_inventory_full_indicator() -> void:
	reward_button.modulate = Color(1,1,1)
	if current_reward is Item:
		if InventoryEvents.inventory_is_full:
			reward_button.modulate = Color(0.3,0.3,0.3)
			reward_button_label.text = "Inventory Full"
		else:
			update_reward_text_blurb()
	else:
		update_reward_text_blurb()

func update_reward_text_blurb() -> void:
	if not current_reward_text_blurb:
		current_reward_text_blurb = basic_reward_text_blurb
	if not current_title_text_blurb:
		current_title_text_blurb = basic_title_text_blurb
	
	reward_button_label.text = current_reward_text_blurb
	title_text_label.text = current_title_text_blurb

func _on_reward_button_pressed() -> void:
	if current_reward is Aura:
		AuraEvents.give_aura_to_player.emit(current_reward)
		reward_selected()
	elif current_reward is Item:
		if not InventoryEvents.inventory_is_full:
			InventoryEvents.send_item_to_inventory.emit(current_reward)
			reward_selected()

func _on_skip_button_pressed() -> void:
	all_done()

func reward_selected() -> void:
	all_done()

func all_done() -> void:
	HudEvents.reward_chosen.emit()

func clear_reward() -> void:
	reward_button_label.text = ""
	reward_button.texture_normal = reward_empty_texture
	reward_button.tooltip_text = ""
	
	current_reward_text_blurb = ""
	current_title_text_blurb = ""
	
	skip_button_container.visible = true
	
	current_reward = null
	current_map_tile = null
