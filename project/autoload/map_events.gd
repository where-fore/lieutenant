extends Node

@warning_ignore_start("unused_signal")
signal venture_to(map_tile:MapTile)
signal enter_combat_in(map_tile:MapTile)
signal enter_without_combat_in(map_tile:MapTile)
signal enter_scenario_in(map_tile:MapTile)
signal combat_all_done()
signal point_of_no_return()
signal maptile_created(map_tile:MapTile)
signal map_grid_ready()
@warning_ignore_restore("unused_signal")
