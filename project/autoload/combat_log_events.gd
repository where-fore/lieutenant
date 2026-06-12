extends Node

@warning_ignore_start("unused_signal")
signal aura_removed(aura:Aura, combatant:Combatant)
signal aura_applied(aura:Aura, combatant:Combatant)
signal item_equipped(item:Item, combatant:Combatant)
signal custom_message(message:String)
@warning_ignore_restore("unused_signal")
