extends Node

var godmode_aura:Aura = load("res://z individual pieces/auras/standalone auras/debug_godmode.gd").new().create_aura()
var godmode_active:bool = false

func apply_godmode() -> void:
	AuraEvents.give_aura_to_player.emit(godmode_aura)
	godmode_active = true

func remove_godmode() -> void:
	AuraEvents.remove_aura_from_player.emit(godmode_aura)
	godmode_active = false

#debug command catcher
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F10:
			if godmode_active: remove_godmode()
			elif not godmode_active: apply_godmode()
			else: push_error("got confused trying to apply godmode")
