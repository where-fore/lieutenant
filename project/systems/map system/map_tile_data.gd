extends Resource
class_name MapTileData

var tile_animation:SpriteFrames
var enemy:CombatantData
var item_reward:Item
var aura_reward:Aura
var internal_name:String

func generate_item_reward_chance_by_power(base_rare_chance:int, rare_chance_increase:int, base_mythic_chance:int, mythic_chance_increase:int) -> void:
	var mythic_chance:int = min(100, base_mythic_chance + mythic_chance_increase)
	var rare_chance:int = min(100, base_rare_chance + rare_chance_increase)
	var roll:int = randi_range(1,100)
	if roll <= mythic_chance:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.MYTHIC).pick_random()
	elif roll <= rare_chance + mythic_chance:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.RARE).pick_random()
	else:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.COMMON).pick_random()

#derived subclasses hook onto this function
@warning_ignore("unused_parameter")
func apply_to_tile(parent_tile:MapTile) -> void:
	pass
