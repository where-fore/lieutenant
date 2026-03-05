extends Resource
class_name ItemData

@export var item_name: String = "Generic Item"
@export var item_sprite: Texture2D


#derived subclasses hook onto these functions
func on_attack(_source:Combatant) -> void:
	#print_debug(_source.baseData.name + " attacked with " + item_name)
	pass
