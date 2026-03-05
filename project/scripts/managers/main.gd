extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	#this gets called when this node is readied
	#and since this script is on the root node, this is after all other nodes are ready
	TimingEvents.everythings_ready.emit()
	#double check the above and warn if otherwise
	if not get_tree().current_scene == self:
		push_error("potential timing issue: 'everything's ready' is being called by the not-root")


# debug stuff
@onready var label: Label = $UIManager/DebugUI/Turn
var prefix: String = "turn: "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = prefix + str($CombatManager.turn)
