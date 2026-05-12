extends Resource
class_name MapTileData

var tile_animation:SpriteFrames
var scenario:Scenario
var enemies:Array[Combatant]
var reward:Reward
var item_reward:Item
var aura_reward:Aura
var internal_name:String

var stops_vision:bool = false

#derived subclasses hook onto this function
@warning_ignore("unused_parameter")
func apply_to_tile(parent_tile:MapTile) -> void:
	pass
