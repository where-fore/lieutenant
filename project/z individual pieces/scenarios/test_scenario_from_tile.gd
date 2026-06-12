extends Scenario

func _init() -> void:
	text_pages = [
		"you're travelling peacefully in the woods...",
		"but then a skeleton appears!",
		"you dust yourself off, and venture on your merry way",
	]
	#display_blurb = "testing"
	#display_sprite = load("res://sprites/hook_sword.png")

func next_page() -> void:
	if current_page == 2:
		ScenarioEvents.begin_combat_with_map_enemy.emit()
		end_combat()
	else: next_page_base()

func end_combat() -> void:
	next_page_base()
