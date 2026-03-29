extends Resource
class_name MapTileData

var tile_animation:SpriteFrames
var enemy:CombatantData
var item_reward:Item
var aura_reward:Aura
var internal_name:String

func generate_item_reward_chance_by_power(chance_increase:int, base_rare_chance:int) -> void:
	var rare_chance:int = min(100, base_rare_chance + chance_increase)
	var common_chance:int = 100-rare_chance
	var roll:int = randi_range(1,100)
	if roll <= rare_chance:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.RARE).pick_random()
	elif roll <= rare_chance + common_chance:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.COMMON).pick_random()
	else:
		item_reward = Database.get_item_by_id("rock")

#derived subclasses hook onto this function
@warning_ignore("unused_parameter")
func apply_to_tile(parent_tile:MapTile) -> void:
	pass
