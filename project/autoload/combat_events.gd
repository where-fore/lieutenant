extends Node

var combat_ongoing:bool = false

@warning_ignore_start("unused_signal")
signal attack_launched(attacker:Combatant, amount:int, target:Combatant)
signal damage_applied(damage_receipient:Combatant, amount:int)
signal healing_applied(heal_receipient:Combatant, amount:int)
signal turn_finished(source:Combatant)
signal player_turn_should_start
signal enemy_turn_should_start
signal pause_button_pressed
signal step_button_pressed
signal play_button_pressed
signal play_fast_button_pressed
signal combatant_died(combatant_who_died:Combatant)
signal prepare_combat_with_enemy(combatants:Array[Combatant])
signal combat_finished(combatants:Array[Combatant])
signal combat_started(combatants:Array[Combatant])
signal combatant_turn_started(source:Combatant)
signal combatant_finished_attack(source:Combatant, target:Combatant)
signal combatant_damaged(source:Combatant, amount_taken:int)
signal combatant_turn_ended(source:Combatant)
@warning_ignore_restore("unused_signal")
