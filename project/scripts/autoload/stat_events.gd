extends Node

@warning_ignore("unused_signal")
signal initalize_combat_stats()

@warning_ignore("unused_signal")
signal give_aura_to_player(aura:Aura)

@warning_ignore("unused_signal")
signal remove_aura_from_player(aura:Aura)

@warning_ignore("unused_signal")
signal send_auras_to_combatants(player_aura_additive_dictonary:Dictionary[StringName, int], player_aura_multiplicative_dictonary:Dictionary[StringName, int], enemy_aura_additive_dictionary:Dictionary[StringName, int], enemy_aura_multiplicative_dictionary:Dictionary[StringName, int])

var encounters_defeated_for_scaling: int = 0

@warning_ignore("unused_signal")
signal restart_game()
