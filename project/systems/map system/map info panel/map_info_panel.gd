extends MarginContainer

@onready var enemy_sprite:TextureRect = $MarginContainer/VBoxContainer/EnemyInfo/EnemySprite
@onready var enemy_blurb:RichTextLabel = $MarginContainer/VBoxContainer/EnemyInfo/EnemyBlurb
@onready var reward_sprite:TextureRect = $MarginContainer/VBoxContainer/RewardInfo/RewardSprite
@onready var reward_blurb:RichTextLabel = $MarginContainer/VBoxContainer/RewardInfo/RewardBlurb
const enemy_blurb_base:String = "Your scouts spot a {enemy_name} in this land."
const item_reward_text_blurb:String = "They also noticed what looked to be a {reward_name}, ripe for the taking."
const aura_reward_text_blurb:String = "A protected spot to resupply."
@onready var venture_button:TextureButton = $MarginContainer/CenterContainer/TextureButton

@onready var close_timer:Timer = $CloseTimer
var time_to_close_panel:float = 5

var current_tile:MapTile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.map_tile_hovered.connect(update_map_tile_info)
	visible = false
	clear_info()
	close_timer.wait_time = time_to_close_panel

func update_map_tile_info(tile:MapTile) -> void:
	clear_info()
	
	current_tile = tile
	var tile_info:MapTileData = tile.tile_data
	visible = true
	begin_to_hide()
	
	if tile_info.enemy:
		enemy_sprite.texture = tile_info.enemy.combatant_texture
		enemy_sprite.tooltip_text = tile_info.enemy.get_tooltip()
		var enemy_name_color:String = Color.ORANGE_RED.to_html()
		var enemy_name_fancy:String = "[color=#%s]%s[/color]" % [enemy_name_color, tile_info.enemy.combatant_name]
		enemy_blurb.text = enemy_blurb_base.format({"enemy_name": enemy_name_fancy})
	
	if tile_info.item_reward:
		reward_sprite.texture = tile_info.item_reward.reward_sprite
		reward_sprite.tooltip_text = tile_info.item_reward.get_tooltip()
		var reward_name_color:String = Color.SKY_BLUE.to_html()
		var reward_name_fancy:String = "[color=#%s]%s[/color]" % [reward_name_color, tile_info.item_reward.reward_name]
		reward_blurb.text = item_reward_text_blurb.format({"reward_name": reward_name_fancy})
	
	if tile_info.aura_reward:
		reward_sprite.texture = tile_info.aura_reward.reward_sprite
		reward_sprite.tooltip_text = tile_info.aura_reward.get_tooltip()
		#var reward_name_color:String = Color.SKY_BLUE.to_html()
		#var reward_name_fancy:String = "[color=#%s]%s[/color]" % [reward_name_color, tile_info.item_reward.reward_name]
		reward_blurb.text = aura_reward_text_blurb
	
	if tile.currently_disabled:
		venture_button.modulate = Color(0.5,0.5,0.5)
		venture_button.tooltip_text = "Path not yet found"
		#note this is wrong, disabled is not checking distance
		#but currently the only things disabled but visible are pemanently visible
	else:
		venture_button.modulate = Color(1,1,1)
		venture_button.tooltip_text = "Begin Combat"
		

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
	enemy_sprite.texture = null
	enemy_blurb.text = ""
	reward_sprite.texture = null
	reward_blurb.text = ""
	current_tile = null

func _on_combat_button_pressed() -> void:
	if not current_tile.currently_disabled:
		MapEvents.venture_to.emit(current_tile)
		hide_map_info_panel()
