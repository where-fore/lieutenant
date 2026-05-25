extends Node

@warning_ignore_start("unused_signal")
signal venture_to(map_tile:MapTile)
signal enter_combat_in(map_tile:MapTile)
signal enter_without_combat_in(map_tile:MapTile)
signal enter_scenario_in(map_tile:MapTile)
signal combat_finished_as_victory
signal combat_finished_as_defeat
signal combat_all_done
signal tile_completed_new_ground
signal tile_completed_no_new_ground
signal tile_all_done
signal maptile_created(map_tile:MapTile)
signal map_grid_ready
signal map_grid_right_edge_visible(visible:bool)
signal map_grid_left_edge_visible(visible:bool)

signal tutorial_camp_encounter_complete
@warning_ignore_restore("unused_signal")
