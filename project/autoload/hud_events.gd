extends Node

enum CombatSpeedNames {STEP, PLAY, PLAY_FAST}
var last_combat_speed_chosen:int = CombatSpeedNames.PLAY

@warning_ignore_start("unused_signal")
signal send_player_combatant_to_ui(player:Combatant)
signal send_enemy_combatants_to_ui(enemies:Array[Combatant])
signal load_portrait_ui
signal unload_portrait_ui
signal combatant_turn_next(combatant:Combatant)
signal combat_button_pressed
signal combat_won
signal combat_lost
signal reward_choosing_complete
signal rout_chosen
signal map_tile_hovered(map_tile:MapTile)
signal map_tile_unhovered
signal map_tile_updated(map_tile:MapTile)
signal game_paused
signal chapter_won
signal chapter_lost
signal chapter_started
signal chapter_completed
signal reward_aiming(reward:Reward)
signal reward_added(combatant:Combatant, new_stat:Reward)
signal reward_removed(combatant:Combatant, new_stat:Reward)
@warning_ignore_restore("unused_signal")
