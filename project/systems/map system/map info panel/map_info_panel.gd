extends MarginContainer

@onready var enemy_info_container:Control = $MarginContainer/VBoxContainer/EnemyInfo
@onready var enemy_sprite:IconWithBorder = $MarginContainer/VBoxContainer/EnemyInfo/EnemySprite
@onready var enemy_blurb:RichTextLabel = $MarginContainer/VBoxContainer/EnemyInfo/EnemyBlurb

@onready var reward_info_container:Control = $MarginContainer/VBoxContainer/RewardInfo
@onready var reward_sprite:IconWithBorder = $MarginContainer/VBoxContainer/RewardInfo/RewardSprite
@onready var reward_blurb:RichTextLabel = $MarginContainer/VBoxContainer/RewardInfo/RewardBlurb

@onready var scenario_blurb_container:Control = $MarginContainer/VBoxContainer/ScenarioBlurb
@onready var scenario_sprite:IconWithBorder = $MarginContainer/VBoxContainer/ScenarioBlurb/ScenarioSprite
@onready var scenario_blurb:RichTextLabel = $MarginContainer/VBoxContainer/ScenarioBlurb/ScenarioBlurb

const enemy_blurb_base:String = "Your scouts spot a {enemy_name} in this land."
const scenario_blurb_base:String = "Your scouts spot nothing. You expect a surprise."
var scenario_sprite_base:Texture2D = load("res://sprites/question.png")
const item_reward_text_blurb:String = "Treasure spotted: {reward_name}, ripe for the taking."
const aura_reward_text_blurb:String = "A protected spot to resupply."
@onready var venture_button:Button = $MarginContainer/CenterContainer/TextureButton

@onready var close_timer:Timer = $CloseTimer
var time_to_close_panel:float = 5

var current_tile:MapTile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.map_tile_hovered.connect(update_map_tile_info)
	HudEvents.map_tile_updated.connect(refresh_current_selection)
	MapEvents.map_scrolled_right.connect(swap_to_left_side_of_screen)
	MapEvents.map_scrolled_left.connect(swap_to_right_side_of_screen)
	
	visible = false
	clear_info()
	close_timer.wait_time = time_to_close_panel

func refresh_current_selection(tile_updated:MapTile) -> void:
	if current_tile:
		if tile_updated == current_tile:
			update_map_tile_info(current_tile)

func update_map_tile_info(tile:MapTile) -> void:
	clear_info()
	
	current_tile = tile
	var tile_info:MapTileData = tile.tile_data
	visible = true
	begin_to_hide()
	
	if tile_info.scenario:
		scenario_blurb_container.visible = true
		enemy_info_container.visible = false
		
		if tile_info.scenario.display_blurb:
			scenario_blurb.text = tile_info.scenario.display_blurb
		else: scenario_blurb.text = scenario_blurb_base
		
		if tile_info.scenario.display_sprite:
			scenario_sprite.set_icon(tile_info.scenario.display_sprite)
		else: scenario_sprite.set_icon(scenario_sprite_base)
		
	else:
		scenario_blurb_container.visible = false
		
		if tile_info.enemies:
			enemy_info_container.visible = true
			
			var display_enemy:Combatant = tile_info.enemies[0]
			
			enemy_sprite.set_icon(display_enemy.combatant_texture)
			enemy_sprite.tooltip_text = display_enemy.get_tooltip()
			
			var enemy_name_color:String = Color.ORANGE_RED.to_html()
			var enemy_name_fancy:String = "[color=#%s]%s[/color]" % [enemy_name_color, display_enemy.combatant_name]
			enemy_blurb.text = enemy_blurb_base.format({"enemy_name": enemy_name_fancy})
		
		if tile_info.reward:
			reward_info_container.visible = true
			
			reward_sprite.set_icon(tile_info.reward.reward_sprite)
			reward_sprite.tooltip_text = tile_info.reward.get_tooltip()
		if tile_info.reward is Aura:
			reward_blurb.text = aura_reward_text_blurb
		elif tile_info.reward is Item:
			var reward_name_color:String = Color.SKY_BLUE.to_html()
			var reward_name_fancy:String = "[color=#%s]%s[/color]" % [reward_name_color, tile_info.reward.reward_name]
			reward_blurb.text = item_reward_text_blurb.format({"reward_name": reward_name_fancy})
	
	if tile.currently_disabled:
		venture_button.modulate = Color(0.5,0.5,0.5)
		venture_button.tooltip_text = "Path not yet found"
		#note this is wrong, disabled is not checking distance
		#but currently the only things disabled but visible are pemanently visible
	else:
		venture_button.modulate = Color(1,1,1)
		venture_button.tooltip_text = "Begin Combat"

func swap_to_right_side_of_screen() -> void:
	swap_to_side_of_screen(Control.PRESET_CENTER_RIGHT)

func swap_to_left_side_of_screen() -> void:
	swap_to_side_of_screen(Control.PRESET_CENTER_LEFT)

func swap_to_side_of_screen(preset:LayoutPreset) -> void:
	set_anchors_and_offsets_preset(preset, Control.PRESET_MODE_KEEP_SIZE)

func begin_to_hide() -> void:
	close_timer.stop() #restart the timer
	close_timer.start()

func stop_hiding() -> void:
	close_timer.stop()

func _on_close_timer_timeout() -> void:
	#hide_map_info_panel()
	#i don't want the map panel to auto hide, for now at least
	pass

func hide_map_info_panel() -> void:
	visible = false
	clear_info()

func _on_mouse_entered() -> void:
	stop_hiding()

func _on_mouse_exited() -> void:
	begin_to_hide()

func clear_info() -> void:
	enemy_sprite.set_icon(null)
	enemy_sprite.tooltip_text = ""
	enemy_blurb.text = ""
	
	reward_sprite.set_icon(null)
	reward_sprite.tooltip_text = ""
	reward_blurb.text = ""
	
	current_tile = null
	scenario_sprite.set_icon(null)
	scenario_sprite.tooltip_text = ""
	
	scenario_blurb_container.visible = false
	enemy_info_container.visible = false
	reward_info_container.visible = false

func _on_combat_button_pressed() -> void:
	if not current_tile.currently_disabled:
		MapEvents.venture_to.emit(current_tile)
		hide_map_info_panel()
