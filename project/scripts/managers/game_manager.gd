extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	
	#this gets called when this node is readied - and since it's the root node, this is after all children are ready
	TimingEvents.everythings_ready.emit()



# debug stuff
@onready var label = $"UI Manager/Debug UI/Turn"
var prefix = "turn: " as String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = prefix + str($"Combat Manager".turn)
