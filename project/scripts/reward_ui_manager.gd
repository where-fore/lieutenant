extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_sword_sprite_pressed() -> void:
	HudEvents.reward_chosen.emit()


func _on_heart_sprite_pressed() -> void:
	HudEvents.reward_chosen.emit()
