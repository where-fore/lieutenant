extends PanelContainer

@onready var main_body_text:RichTextLabel = $Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var continue_button:TextureButton = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/ContinueButton
@onready var next_page_button:TextureButton = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/NextPageButton
@onready var complete_chapter_button:TextureButton = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/CompleteChapterButton
@onready var lost_game_button:TextureButton = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/LostGameButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.chapter_won.connect(win_chapter)
	HudEvents.chapter_lost.connect(lose_chapter)
	HudEvents.chapter_started.connect(start_chapter)
	ScenarioEvents.updated.connect(update_blurb_to_event)
	ScenarioEvents.on_last_page.connect(change_next_button_to_continue)
	ScenarioEvents.begin_combat_with.connect(change_to_combat)
	ScenarioEvents.completed_combat_as_victory.connect(resume_scenario_as_victory)
	ScenarioEvents.completed_combat_as_loss.connect(resume_scenario_as_loss)
	
	hide_screen()

func win_chapter() -> void:
	show_screen()
	complete_chapter_button.visible = true
	main_body_text.text = "Conquered all foes\nand saved the land!"

func lose_chapter() -> void:
	show_screen()
	lost_game_button.visible = true
	main_body_text.text = "You perished fighting\nfor what you thought\nwas right."

func start_chapter() -> void:
	show_screen()
	next_page_button.visible = true
	ScenarioEvents.load_tutorial_first_scenario()

func resume_tutorial() -> void:
	pass

func update_blurb_to_event() -> void:
	main_body_text.text = ScenarioEvents.current_scenario.get_current_text()

func change_next_button_to_continue() -> void:
	next_page_button.visible = false
	continue_button.visible = true

func resume_scenario_as_victory() -> void:
	next_page_button.visible = true
	ScenarioEvents.current_scenario.end_combat()
	show_screen()

func resume_scenario_as_loss() -> void:
	next_page_button.visible = true
	ScenarioEvents.current_scenario.end_combat()
	show_screen()

func change_to_combat(_enemy:Combatant) -> void:
	hide_screen()

func show_screen() -> void:
	visible = true

func hide_screen() -> void:
	visible = false
	continue_button.visible = false
	complete_chapter_button.visible = false
	lost_game_button.visible = false
	next_page_button.visible = false

func _on_next_page_button_pressed() -> void:
	if not ScenarioEvents.current_scenario: push_error("pressed next page with no scenario loaded")
	ScenarioEvents.current_scenario.next_page()

func _on_continue_button_pressed() -> void:
	hide_screen()
	ScenarioEvents.finish_scenario()

func _on_complete_chapter_button_pressed() -> void:
	hide_screen()
	HudEvents.chapter_completed.emit()

func _on_lost_game_button_pressed() -> void:
	_on_complete_chapter_button_pressed()
