extends Control

@export var reward_empty_texture:Texture2D

@onready var edit_border:TextureRect = $EditBorder

@onready var reward_button_icon:IconWithBorder = $Panel/VBoxContainer/RewardButtons/RewardButton/VBoxContainer/RewardButton/MarginContainer/RewardIcon
@onready var reward_button_container:Control = $Panel/VBoxContainer/RewardButtons/RewardButton
@onready var reward_button_label:Label = $Panel/VBoxContainer/RewardButtons/RewardButton/VBoxContainer/Label
@onready var reward_button:Button = $Panel/VBoxContainer/RewardButtons/RewardButton/VBoxContainer/RewardButton

@onready var basic_reward_button_icon:IconWithBorder = $Panel/VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/BasicRewardButton/MarginContainer/BasicRewardIcon
@onready var basic_reward_button_container:Control = $Panel/VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/BasicRewardButton
@onready var basic_reward_button_label:Label = $Panel/VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/Label
@onready var basic_reward_button:Button = $Panel/VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/BasicRewardButton

@onready var or_label:Label = $Panel/VBoxContainer/RewardButtons/OrLabel

@onready var title_text_label:Label = $Panel/VBoxContainer/Title
@onready var skip_button_container:MarginContainer = $Panel/SkipRewardButton

var basic_title_text_blurb:String = "Victory.\nClaim your boon."
var basic_waiting_to_apply_text_blurb:String = "Choose the hero to favour."
var current_title_text_blurb:String
var basic_reward_text_blurb:String = "Gather\nyour\nprize"
var current_reward_text_blurb:String

var current_reward:Reward
var current_basic_reward:Reward
var current_map_tile:MapTile

var is_a_reward_prepped:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapEvents.venture_to.connect(prepare_from_map_tile)
	ScenarioEvents.setup_reward.connect(prepare_from_scenario)
	ScenarioEvents.present_rewards.connect(change_to)
	CursorManager.clear_hovered_reward.connect(reward_selected)
	HudEvents.rout_chosen.connect(clear_reward)
	
	edit_border.visible = false
	
	setup_basic_rewards()
	clear_reward()

func change_to() -> void:
	if current_map_tile:
		if current_map_tile.end_of_chapter:
			HudEvents.chapter_won.emit()
			return #closes this whole function
	
	if is_a_reward_prepped:
		visible = true
		HudEvents.load_portrait_ui.emit()
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
		return #stop this function here
	if current_map_tile.tile_data.scenario:
		return #stop this function here
	
	if current_map_tile.tile_data.basic_reward:
		prepare_basic_reward()
		
	if current_map_tile.tile_data.reward:
		current_reward = current_map_tile.tile_data.reward
	prepare_reward()
	
	if reward_button_container.visible == true and basic_reward_button_container.visible == true:
		or_label.visible = true

func prepare_from_scenario(reward:Reward) -> void:
	if not (reward is Reward):
		push_error("tried to prepare reward from scenario, but was given class: " + reward.get_class())
	clear_reward()
	current_reward = reward
	prepare_reward()

func prepare_reward() -> void:
	
	if current_reward:
		reward_button_container.visible = true
		reward_button_icon.set_icon(current_reward.reward_sprite)
		reward_button.tooltip_text = current_reward.get_tooltip()
		
		is_a_reward_prepped = true
	elif not current_reward:
		reward_button_container.visible = false
		#current_reward_text_blurb = "Found nothing..."
		#reward_button_icon.set_icon(reward_empty_texture)
		#reward_button_container.tooltip_text = "Continue..."
	
	update_reward_text_blurb()

func prepare_basic_reward() -> void:
	basic_reward_button_container.visible = true
	
	var basic_aura_array:Array[Aura] = setup_basic_rewards()
	current_basic_reward = basic_aura_array.pick_random()
	basic_reward_button_icon.set_icon(current_basic_reward.reward_sprite)
	basic_reward_button.tooltip_text = current_basic_reward.get_tooltip()
	basic_reward_button_label.text = "Gather\nHerbs"
	
	is_a_reward_prepped = true

func setup_basic_rewards() -> Array[Aura]:
	var basic_reward_array:Array[Aura]
	basic_reward_array.assign(Database.get_rewards_by_category(Categories.aura_rarity, [Categories.AuraRarity.BASIC_STAT]))

	return basic_reward_array

func update_reward_text_blurb() -> void:
	current_reward_text_blurb = basic_reward_text_blurb
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
	reward_button_icon.set_icon(reward_empty_texture)
	reward_button.tooltip_text = ""
	reward_button_container.visible = false
	
	basic_reward_button_label.text = ""
	basic_reward_button_icon.set_icon(reward_empty_texture)
	basic_reward_button.tooltip_text = ""
	basic_reward_button_container.visible = false
	
	or_label.visible = false
	
	current_reward_text_blurb = ""
	current_title_text_blurb = ""
	
	skip_button_container.visible = true
	
	current_reward = null
	current_basic_reward = null
	current_map_tile = null
	
	is_a_reward_prepped = false
