extends Control

@export var reward_empty_texture:Texture2D

@onready var edit_border:TextureRect = $EditBorder

@onready var reward_button:TextureButton = $Panel/VBoxContainer/RewardButtons/RewardButton/VBoxContainer/TextureButton
@onready var reward_button_container:MarginContainer = $Panel/VBoxContainer/RewardButtons/RewardButton
@onready var reward_button_label:Label = $Panel/VBoxContainer/RewardButtons/RewardButton/VBoxContainer/Label

@onready var basic_reward_button:TextureButton = $Panel/VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/TextureButton
@onready var basic_reward_button_container:MarginContainer = $Panel/VBoxContainer/RewardButtons/BasicRewardButton
@onready var basic_reward_button_label:Label = $Panel/VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/Label

@onready var or_label:Label = $Panel/VBoxContainer/RewardButtons/OrLabel

@onready var title_text_label:Label = $Panel/VBoxContainer/Title
@onready var skip_button_container:MarginContainer = $Panel/SkipRewardButton

var basic_title_text_blurb:String = "Victory.\nClaim your boon."
var basic_waiting_to_apply_text_blurb:String = "Choose the hero to favour."
var current_title_text_blurb:String
var basic_reward_text_blurb:String = "Gather\nyour prize"
var current_reward_text_blurb:String

var current_reward:Reward
var current_basic_reward:Reward
var current_map_tile:MapTile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapEvents.venture_to.connect(prepare_from_map_tile)
	ScenarioEvents.setup_reward.connect(prepare_from_scenario)
	ScenarioEvents.present_rewards.connect(change_to)
	CursorManager.clear_hovered_reward.connect(reward_selected)
	
	edit_border.visible = false
	
	setup_basic_rewards()
	clear_reward()

func change_to() -> void:
	if current_map_tile:
		if current_map_tile.end_of_chapter:
			HudEvents.chapter_won.emit()
			return #closes this whole function
	
	if current_reward:
		visible = true
		HudEvents.load_portrait_ui.emit()
		if reward_button_container.visible == true and basic_reward_button_container.visible == true:
			or_label.visible = true
	else:
		#print_debug("skipping rewards, since none was prepped")
		all_done()

func change_from() -> void:
	clear_reward()
	HudEvents.unload_portrait_ui.emit()
	visible = false

func prepare_from_map_tile(map_tile:MapTile) -> void:
	current_map_tile = map_tile
	
	if current_map_tile.end_of_chapter:
		pass
	else:
		if current_map_tile.tile_data.reward:
			current_reward = current_map_tile.tile_data.reward
		if not ScenarioEvents.tutorial_stage: prepare_basic_reward()
		prepare_reward()

func prepare_from_scenario(reward:Reward) -> void:
	if (not reward is Reward):
		push_error("tried to prepare reward from scenario, but was given class: " + reward.get_class())
	clear_reward()
	current_reward = reward
	prepare_reward()

func prepare_reward() -> void:
	reward_button_container.visible = true
	
	if current_reward:
		reward_button.texture_normal = current_reward.reward_sprite
		reward_button.tooltip_text = current_reward.get_tooltip()
	elif not current_reward:
		current_reward_text_blurb = "Found nothing..."
		reward_button.texture_normal = reward_empty_texture
		reward_button.tooltip_text = "Continue..."
	
	update_text_blurb_and_inventory_full_indicator()

func prepare_basic_reward() -> void:
	basic_reward_button_container.visible = true
	
	var basic_aura_array:Array[Aura] = setup_basic_rewards()
	current_basic_reward = basic_aura_array.pick_random()
	basic_reward_button.texture_normal = current_basic_reward.reward_sprite
	basic_reward_button.tooltip_text = current_basic_reward.get_tooltip()
	basic_reward_button_label.text = "Rest"

func update_text_blurb_and_inventory_full_indicator() -> void:
	reward_button.modulate = Color(1,1,1)
	if current_reward is Item:
		#should check on hover, maybe on the cursor
		#if combatant.inventory_is_full() then tooltip.text = "inventory full"
		#if InventoryEvents.inventory_is_full:
			#reward_button.modulate = Color(0.3,0.3,0.3)
			#reward_button_label.text = "Inventory Full"
		#else:
		update_reward_text_blurb()
	else:
		update_reward_text_blurb()

func setup_basic_rewards() -> Array[Aura]:
	var basic_reward_array:Array[Aura]
	
	var rest_aura:Aura = load("res://z individual pieces/auras/standalone auras/rested.gd").new() as Aura
	basic_reward_array.append(rest_aura.create_aura())
	var sharpen_aura:Aura = load("res://z individual pieces/auras/standalone auras/sharpen.gd").new() as Aura
	basic_reward_array.append(sharpen_aura.create_aura())
	
	return basic_reward_array

func update_reward_text_blurb() -> void:
	if not current_reward_text_blurb:
		current_reward_text_blurb = basic_reward_text_blurb
	if not current_title_text_blurb:
		current_title_text_blurb = basic_title_text_blurb
	
	reward_button_label.text = current_reward_text_blurb
	title_text_label.text = current_title_text_blurb

func _on_reward_button_pressed() -> void:
	accept_reward(current_reward)

func _on_basic_reward_button_pressed() -> void:
	accept_reward(current_basic_reward)

func accept_reward(reward:Reward) -> void:
	HudEvents.reward_aiming.emit(reward)
	clear_reward()
	skip_button_container.visible = false
	title_text_label.text = basic_waiting_to_apply_text_blurb

func _on_skip_button_pressed() -> void:
	all_done()

func reward_selected() -> void:
	all_done()

func all_done() -> void:
	HudEvents.reward_choosing_complete.emit()

func clear_reward() -> void:
	reward_button_label.text = ""
	reward_button.texture_normal = reward_empty_texture
	reward_button.tooltip_text = ""
	reward_button_container.visible = false
	
	basic_reward_button_label.text = ""
	basic_reward_button.texture_normal = reward_empty_texture
	basic_reward_button.tooltip_text = ""
	basic_reward_button_container.visible = false
	
	or_label.visible = false
	
	current_reward_text_blurb = ""
	current_title_text_blurb = ""
	
	skip_button_container.visible = true
	
	current_reward = null
	current_basic_reward = null
	current_map_tile = null
