extends CanvasLayer

var attack_per_upgrade = 2
var health_per_upgrade = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_to():
	visible = true

func change_from():
	visible = false


func _on_sword_sprite_pressed() -> void:
	StatEvents.attack_increased.emit(attack_per_upgrade)
	HudEvents.reward_chosen.emit()


func _on_heart_sprite_pressed() -> void:
	HudEvents.reward_chosen.emit()
	StatEvents.health_increased.emit(health_per_upgrade)
