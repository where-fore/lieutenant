extends Node

@warning_ignore("unused_signal")
signal player_health_update(value: int)

@warning_ignore("unused_signal")
signal enemy_health_update(value: int)

@warning_ignore("unused_signal")
signal player_attack_update(value: int)

@warning_ignore("unused_signal")
signal enemy_attack_update(value: int)

@warning_ignore("unused_signal")
signal combat_button_pressed()

@warning_ignore("unused_signal")
signal combat_won()

@warning_ignore("unused_signal")
signal combat_lost()

@warning_ignore("unused_signal")
signal reward_chosen()

@warning_ignore("unused_signal")
signal change_to_combat_screen()

@warning_ignore("unused_signal")
signal send_enemy_sprite(sprite:Texture2D)
