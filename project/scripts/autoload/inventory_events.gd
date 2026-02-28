extends Node

@warning_ignore("unused_signal")
signal item_successfully_equipped(item:ItemData)

@warning_ignore("unused_signal")
signal item_successfully_unequipped(item:ItemData)

@warning_ignore("unused_signal")
signal send_item_to_inventory(item:ItemData)

@warning_ignore("unused_signal")
signal slot_updated()

var inventory_is_full:bool = false
@warning_ignore("unused_signal")
signal full_status_updated()
