extends Node

@warning_ignore("unused_signal")
signal item_successfully_equipped(item:Item)

@warning_ignore("unused_signal")
signal item_successfully_unequipped(item:Item)

@warning_ignore("unused_signal")
signal send_item_to_inventory(item:Item)

@warning_ignore("unused_signal")
signal slot_updated()

var inventory_is_full:bool = false
@warning_ignore("unused_signal")
signal full_status_updated()

@warning_ignore("unused_signal")
signal clear_all_to_restart()

@warning_ignore("unused_signal")
signal rebuild_all_to_restart()
