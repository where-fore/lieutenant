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
	
	if current_page == text_length:
		ScenarioEvents.on_last_page.emit()

func get_current_text() -> String:
	if current_page <= 0: push_error("trying to get text of page " + str(current_page) + " of event")
	return text_pages[current_page-1] # 0-indexed array

func start_scenario() -> void:
	current_page = 1

#derived subclasses hook onto these functions

func next_page() -> void:
	pass

func end_combat() -> void:
	pass
