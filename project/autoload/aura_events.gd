extends Node

@warning_ignore_start("unused_signal")
signal initalize_combat_stats()
signal give_aura_to_player(aura:Aura)
signal remove_aura_from_player(aura:Aura)
signal give_aura_to_enemy(aura:Aura)
signal remove_aura_from_enemy(aura:Aura)
signal send_auras_to_combatants(player_aura_additive_dictonary:Dictionary[StringName, int], player_aura_multiplicative_dictonary:Dictionary[StringName, int], enemy_aura_additive_stat_dictionary:Dictionary[StringName, int], enemy_aura_multiplicative_stat_dictionary:Dictionary[StringName, int])
signal restart_game()
signal updated_aura(aura:Aura)
signal expired_aura(aura:Aura)
@warning_ignore_restore("unused_signal")
