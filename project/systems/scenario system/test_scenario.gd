extends Scenario

func _init() -> void:
	text_pages = [
		"first page",
		"second page",
		"third page",
	]

func next_page() -> void:
	if current_page == 2:
		print_debug("do thing after page 2")
		end_combat()
	else: next_page_base()

func end_combat() -> void:
	next_page_base()
