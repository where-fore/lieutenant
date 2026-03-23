extends Control

@export var basic_reward:Array[GDScript]

@onready var basic_reward_button:TextureButton = $VBoxContainer/RewardButtons/BasicRewardButton/VBoxContainer/TextureButton
@onready var basic_reward_button_container:MarginContainer = $VBoxContainer/RewardButtons/BasicRewardButton
@onready var search_button:TextureButton = $VBoxContainer/RewardButtons/SearchButton/VBoxContainer/TextureButton
@onready var search_button_container:MarginContainer = $VBoxContainer/RewardButtons/SearchButton
@onready var search_reward_button:TextureButton = $VBoxContainer/RewardButtons/SearchRewardButton/VBoxContainer/TextureButton
@onready var search_reward_button_container:MarginContainer = $VBoxContainer/RewardButtons/SearchRewardButton
@onready var search_reward_button_label:Label = $VBoxContainer/RewardButtons/SearchRewardButton/VBoxContainer/Label
@onready var search_skip_button_container:MarginContainer = $VBoxContainer/SkipRewardButton

@onready var search_reward_empty_texture:Texture2D = search_reward_button.texture_normal

var search_reward_text_blurb:String = "The spoils of war"

var search_button_should_advance:bool
var current_basic_aura:Aura
var current_search_reward:Item
var rare_chance:int = 50
var common_chance:int = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryEvents.full_status_updated.connect(update_inventory_full_indicator)

func change_to() -> void:
	basic_reward_button_container.visible = true
	search_button_container.visible = true
	search_reward_button_container.visible = false
	search_skip_button_container.visible = true
	generate_basic_reward()
	visible = true

func change_from() -> void:
	visible = false

func generate_basic_reward() -> void:
	var reward:Aura = basic_reward.pick_random().new().create_aura()
	basic_reward_button.texture_normal = reward.aura_sprite
	basic_reward_button.tooltip_text = reward.get_tooltip()
	current_basic_aura = reward

func search_for_rare_reward() -> void:
	basic_reward_button_container.visible = false
	search_button_container.visible = false
	search_reward_button_container.visible = true
	search_skip_button_container.visible = true
	
	search_reward_button_label.text = ""
	search_reward_button.texture_normal = search_reward_empty_texture
	search_reward_button.tooltip_text = ""
	
	var roll:int = randi_range(1,100)
	if rare_chance + common_chance > 100: push_error("loot roll table exceeded 100%")
	if roll <= rare_chance:
		current_search_reward = Database.get_items_by_category(ItemCategories.rare_item).pick_random()
	elif roll <= rare_chance + common_chance:
		current_search_reward = Database.get_items_by_category(ItemCategories.common_item).pick_random()
	else:
		pass
	
	if current_search_reward:
		search_reward_button_label.text = search_reward_text_blurb
		search_reward_button.texture_normal = current_search_reward.item_sprite
		search_reward_button.tooltip_text = current_search_reward.get_tooltip()
	else:
		search_reward_button.texture_normal = search_reward_empty_texture
		search_reward_button.tooltip_text = "Continue..."
		search_reward_button_label.text = "Found nothing..."
	
	search_button_should_advance = true
	update_inventory_full_indicator()

func update_inventory_full_indicator() -> void:
	if current_search_reward:
		if InventoryEvents.inventory_is_full:
			search_reward_button.modulate = Color(0.3,0.3,0.3)
			search_reward_button_label.text = "Inventory Full"
			search_button_should_advance = false
		else:
			search_reward_button.modulate = Color(1,1,1)
			search_reward_button_label.text = search_reward_text_blurb
			search_button_should_advance = true

func _on_basic_reward_button_pressed() -> void:
	AuraEvents.give_aura_to_player.emit(current_basic_aura)
	current_basic_aura = null
	reward_selected()

func _on_search_button_pressed() -> void:
	search_for_rare_reward()

func _on_search_reward_button_pressed() -> void:
	if search_button_should_advance:
		if current_search_reward: InventoryEvents.send_item_to_inventory.emit(current_search_reward)
		current_search_reward = null
		reward_selected()

func _on_search_skip_button_pressed() -> void:
	current_search_reward = null
	reward_selected()

func reward_selected() -> void:
	HudEvents.reward_chosen.emit()
