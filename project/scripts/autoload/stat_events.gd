extends Node

@warning_ignore("unused_signal")
signal health_increased(delta:int)

@warning_ignore("unused_signal")
signal attack_increased(delta:int)

@warning_ignore("unused_signal")
signal initalize_combat_stats()

@warning_ignore("unused_signal")
signal send_auras_to_combatants(player_aura_dictonary:Dictionary[StringName, int], enemy_aura_dictionary:Dictionary[StringName, int])

var encounters_defeated_for_scaling: int = 0

@warning_ignore("unused_signal")
signal restart_game()
