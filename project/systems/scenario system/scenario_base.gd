extends Resource
class_name Scenario

var text_pages:Array[String]
var current_page:int = 0
var enemies:Array[Combatant]
var item_rewards:Array[Item]
var aura_rewards:Array[Aura]

func next_page_base() -> void:
	var amount_of_pages:int = text_pages.size()
	if current_page < amount_of_pages:
		current_page += 1
		ScenarioEvents.updated.emit()
	else: pass
	
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

#derived subclasses hook onto and overwrite these functions
func next_page() -> void:
	next_page_base()

func end_combat() -> void:
	next_page_base()

#called by ScenarioEvents
func on_finish_scenario() -> void:
	pass
