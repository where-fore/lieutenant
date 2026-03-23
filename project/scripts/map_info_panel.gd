extends MarginContainer

@onready var enemy_sprite:TextureRect = $MarginContainer/VBoxContainer2/EnemySprite
@onready var enemy_blurb:RichTextLabel = $MarginContainer/VBoxContainer2/EnemyBlurb
@onready var reward_sprite:TextureRect = $MarginContainer/VBoxContainer/RewardSprite
@onready var reward_blurb:RichTextLabel = $MarginContainer/VBoxContainer/RewardBlurb
const enemy_blurb_base:String = "Your scouts spot a {enemy_name} in this land."
const reward_blurb_base:String = "They also noticed what looked to be a {reward_name}, ripe for the taking."

@onready var close_timer:Timer = $CloseTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.map_tile_hovered.connect(update_map_tile_info)
	HudEvents.map_tile_unhovered.connect(begin_to_hide)
	visible = false
	enemy_sprite.texture = null
	enemy_blurb.text = ""
	reward_sprite.texture = null
	reward_blurb.text = ""

func update_map_tile_info(tile_info:MapTileData) -> void:
	visible = true
	stop_hiding()
	if tile_info.enemy:
		enemy_sprite.texture = tile_info.enemy.texture
		enemy_sprite.tooltip_text = tile_info.enemy.extra_tooltip
		var enemy_name_color:String = Color.ORANGE_RED.to_html()
		var enemy_name_fancy:String = "[color=#%s]%s[/color]" % [enemy_name_color, tile_info.enemy.name]
		enemy_blurb.text = enemy_blurb_base.format({"enemy_name": enemy_name_fancy})
	
	if tile_info.item_reward:
		reward_sprite.texture = tile_info.item_reward.item_sprite
		reward_sprite.tooltip_text = tile_info.item_reward.get_tooltip()
		var reward_name_color:String = Color.SKY_BLUE.to_html()
		var reward_name_fancy:String = "[color=#%s]%s[/color]" % [reward_name_color, tile_info.item_reward.item_name]
		reward_blurb.text = reward_blurb_base.format({"reward_name": reward_name_fancy})

func begin_to_hide() -> void:
	close_timer.start()

func stop_hiding() -> void:
	close_timer.stop()

func _on_close_timer_timeout() -> void:
	hide_map_info_panel()

func hide_map_info_panel() -> void:
	visible = false

func _on_mouse_entered() -> void:
	stop_hiding()

func _on_mouse_exited() -> void:
	begin_to_hide()
