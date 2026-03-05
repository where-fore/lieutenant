extends Node

@warning_ignore("unused_signal")
signal attack_launched(attacker:Combatant, amount:int)

@warning_ignore("unused_signal")
signal turn_finished()

@warning_ignore("unused_signal")
signal player_turn_should_start()

@warning_ignore("unused_signal")
signal enemy_turn_should_start()

@warning_ignore("unused_signal")
signal pause_button_pressed()

@warning_ignore("unused_signal")
signal step_button_pressed()

@warning_ignore("unused_signal")
signal play_button_pressed()

@warning_ignore("unused_signal")
signal combatant_died(combatant_who_died:Combatant)

var combat_ongoing: bool = false

@warning_ignore("unused_signal")
signal enemy_ready()
