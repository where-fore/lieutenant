extends Resource
class_name Scenario

var text_pages:Array[String]
var current_page:int = 0
var enemies:Array[Combatant]
var rewards:Array[Reward]
var display_blurb:String
var display_sprite:Texture2D

func next_page_base() -> void:
	print_stack()
	print_debug("starting on page: ", current_page)
	var amount_of_pages:int = text_pages.size()
	if current_page < amount_of_pages:
		current_page += 1
		ScenarioEvents.updated.emit()
	else: pass
	print_debug("now loading page: ", current_page)
	
	check_if_on_last_page()

func get_current_text() -> String:
	if current_page <= 0: push_error("trying to get text of page " + str(current_page) + " of event")
	return text_pages[current_page-1] # 0-indexed array

func start_scenario() -> void:
	current_page = 1
	check_if_on_last_page()

func check_if_on_last_page() -> void:
	var amount_of_pages:int = text_pages.size()
	if current_page == amount_of_pages:
		ScenarioEvents.on_last_page.emit()

func basic_scale_enemy_stats_by_day() -> void:
	if enemies:
		for enemy:Combatant in enemies:
			if is_instance_valid(enemy):
				enemy.scale_stats_basic_exponential(TimeOfDay.current_day)
			else:
				#let's clear it out
				#there's probably better places to do this,
				#but it's a failsafe?
				enemies.erase(enemy)

func encounter_this_scenario() -> void:
	generate_encounters()
	scale_scenario_to_time()

#derived subclasses hook onto and overwrite these functions
func next_page() -> void:
	next_page_base()

func end_combat() -> void:
	next_page_base()

func generate_encounters() -> void:
	pass

func scale_scenario_to_time() -> void:
	basic_scale_enemy_stats_by_day()

#called by ScenarioEvents
func on_finish_scenario() -> void:
	pass
