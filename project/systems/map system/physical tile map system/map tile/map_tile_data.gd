extends Resource
class_name MapTileData

var tile_animation:SpriteFrames
var scenario:Scenario
var enemies:Array[Combatant]
var reward:Reward
var basic_reward:bool = false
var item_reward:Item
var aura_reward:Aura
var script_path:String

var stops_vision:bool = false

func setup() -> void:
	set_script_path_to_file_name()

func set_script_path_to_file_name() -> void:
	script_path = get_script().resource_path.get_file().get_basename()

func basic_scale_stats_by_day() -> void:
	if enemies:
		for enemy:Combatant in enemies:
			if is_instance_valid(enemy):
				enemy.scale_stats_to_day()
			else:
				#let's clear it out
				#there's probably better places to do this,
				#but it's a failsafe?
				enemies.erase(enemy)

func chance_to_have_no_item(chance:int) -> void:
	if not chance or chance < 1 or chance > 100:
		push_error("expected a 1 to 100 chance, was given: ", chance)
		return
	
	var roll:int = randi_range(1, 100)
	if roll <= chance:
		reward = null

#derived subclasses hook onto this function
@warning_ignore("unused_parameter")
func apply_to_tile(parent_tile:MapTile) -> void:
	pass

func scale_stats() -> void:
	basic_scale_stats_by_day()

func generate_encounters() -> void:
	pass
