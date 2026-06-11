extends Control

@onready var edit_border:TextureRect = $EditBorder

@export var reward_button_template:PackedScene
@export var reward_buttons_container:Control

@onready var title_text_label:Label = $Panel/VBoxContainer/Title

var basic_title_text_blurb:String = "Victory.\nClaim a boon."
var basic_waiting_to_apply_text_blurb:String = "Choose the hero to favour."
var current_title_text_blurb:String

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
	
	clear_reward()

func change_to() -> void:
	if current_map_tile:
		if current_map_tile.end_of_chapter:
			HudEvents.chapter_won.emit()
				#this shit should not be in the reward ui
				#the map tile should probably emit a signal when defeated if end_of_chapter
			return #closes this whole function
	
	if is_a_reward_prepped:
		visible = true
		HudEvents.load_portrait_ui.emit()
	else:
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
		create_reward_button(grab_a_basic_reward())
		
	if current_map_tile.tile_data.reward:
		create_reward_button(current_map_tile.tile_data.reward)

func prepare_from_scenario(reward:Reward) -> void:
	if not (reward is Reward):
		push_error("tried to prepare reward from scenario, but was given class: " + reward.get_class())
	clear_reward()
	create_reward_button(reward)

func grab_a_basic_reward() -> Aura:
	var basic_reward_array:Array[Aura]
	basic_reward_array.assign(Database.get_rewards_by_category(Categories.aura_rarity, [Categories.AuraRarity.BASIC_STAT]))

	return basic_reward_array.pick_random()

func create_reward_button(reward_to_assign:Reward) -> void:
	is_a_reward_prepped = true
	
	var new_reward_button:RewardButton = reward_button_template.instantiate()
	reward_buttons_container.add_child(new_reward_button)
	new_reward_button.assign_reward(reward_to_assign)
	new_reward_button.reward_button_pressed.connect(_on_reward_button_pressed)

func _on_reward_button_pressed(button:RewardButton) -> void:
	accept_reward(button.reward_assigned)

func accept_reward(reward:Reward) -> void:
	HudEvents.reward_aiming.emit(reward)
	clear_reward()
	title_text_label.text = basic_waiting_to_apply_text_blurb

func _on_skip_button_pressed() -> void:
	all_done()

func reward_selected() -> void:
	all_done()

func all_done() -> void:
	HudEvents.reward_choosing_complete.emit()

func clear_reward() -> void:
	title_text_label.text = basic_title_text_blurb
	
	current_map_tile = null
	
	is_a_reward_prepped = false
	
	for child:Node in reward_buttons_container.get_children():
		if child is RewardButton:
			child.clean_up()
