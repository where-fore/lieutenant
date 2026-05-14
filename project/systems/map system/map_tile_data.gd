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

func basic_scale_stats_by_day() -> void:
	if enemies:
		for enemy:Combatant in enemies:
			if is_instance_valid(enemy):
				enemy.scale_stats_basic_exponential(TimeOfDay.current_day)
			else:
				#let's clear it out
				#there's probably better places to do this,
				#but it's a failsafe?
				enemies.erase(enemy)

#derived subclasses hook onto this function
@warning_ignore("unused_parameter")
func apply_to_tile(parent_tile:MapTile) -> void:
	pass

func scale_stats() -> void:
	basic_scale_stats_by_day()

func generate_encounters() -> void:
	pass
