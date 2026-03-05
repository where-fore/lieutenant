extends Resource
class_name ItemData

@export var item_name: String = "Generic Item"
@export var item_sprite: Texture2D
var custom_tooltip: String = ""
@export var custom_aura: Aura


#derived subclasses hook onto these functions
func on_attack(_source:Combatant) -> void:
	#print_debug(_source.baseData.name + " attacked with " + item_name)
	pass

func add_custom_tooltip(custom_tooltip_text: String) -> void:
	custom_tooltip += custom_tooltip_text

func _ready() -> void:
	if item_sprite == null: push_error("Item in inventory has no sprite: " + item_name)
