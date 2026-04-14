extends Node

var inventory_is_full:bool = false

@warning_ignore_start("unused_signal")
signal item_successfully_equipped(item:Item)
signal item_successfully_unequipped(item:Item)
signal send_item_to_inventory(item:Item)
signal slot_updated()
signal full_status_updated()
signal clear_all_to_restart()
signal rebuild_all_to_restart()
@warning_ignore_restore("unused_signal")
