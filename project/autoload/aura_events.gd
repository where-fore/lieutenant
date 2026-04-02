extends Node

@warning_ignore("unused_signal")
signal initalize_combat_stats()

@warning_ignore("unused_signal")
signal give_aura_to_player(aura:Aura)

@warning_ignore("unused_signal")
signal remove_aura_from_player(aura:Aura)

@warning_ignore("unused_signal")
signal give_aura_to_enemy(aura:Aura)

@warning_ignore("unused_signal")
signal remove_aura_from_enemy(aura:Aura)

@warning_ignore("unused_signal")
signal send_auras_to_combatants(player_aura_additive_dictonary:Dictionary[StringName, int], player_aura_multiplicative_dictonary:Dictionary[StringName, int], enemy_aura_additive_stat_dictionary:Dictionary[StringName, int], enemy_aura_multiplicative_stat_dictionary:Dictionary[StringName, int])

@warning_ignore("unused_signal")
signal restart_game()

@warning_ignore("unused_signal")
signal updated_aura(aura:Aura)

@warning_ignore("unused_signal")
signal expired_aura(aura:Aura)
