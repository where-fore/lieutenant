extends Resource
class_name Scenario

var text_pages:Array[String]
var current_page:int = 0
var enemies:Array[Combatant]
var item_rewards:Array[Item]
var aura_rewards:Array[Aura]

func next_page_base() -> void:
	var text_length:int = text_pages.size()
	if current_page < text_length:
		current_page += 1
		ScenarioEvents.updated.emit()
	else: push_error("tried to go the next page of an event, when already at the last page")
	
	check_if_on_last_page()

func get_current_text() -> String:
	if current_page <= 0: push_error("trying to get text of page " + str(current_page) + " of event")
	return text_pages[current_page-1] # 0-indexed array

func start_scenario() -> void:
	current_page = 1
	check_if_on_last_page()
	

func check_if_on_last_page() -> void:
	var text_length:int = text_pages.size()
	if current_page >= text_length:
		ScenarioEvents.on_last_page.emit()

#derived subclasses hook onto and overwrite these functions
func next_page() -> void:
	next_page_base()

func end_combat() -> void:
	next_page_base()
