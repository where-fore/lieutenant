extends PanelContainer

@onready var main_body_text:RichTextLabel = $Panel/MarginContainer/VBoxContainer/RichTextLabel
@onready var continue_button:TextureButton = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/ContinueButton
@onready var complete_chapter_button:TextureButton = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/CompleteChapterButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.chapter_won.connect(win_chapter)
	HudEvents.chapter_lost.connect(lose_chapter)
	HudEvents.chapter_started.connect(start_chapter)
	
	hide_screen()

func win_chapter() -> void:
	show_screen()
	complete_chapter_button.visible = true
	main_body_text.text = "Conquered all foes\nand saved the land!"

func lose_chapter() -> void:
	show_screen()
	complete_chapter_button.visible = true
	main_body_text.text = "You perished fighting\nfor what you thought\nwas right."

func start_chapter() -> void:
	show_screen()
	continue_button.visible = true
	main_body_text.text = "Your quest begins.\n\nThe enemy must be stopped before\nthey complete their ritual."

func show_screen() -> void:
	visible = true

func hide_screen() -> void:
	visible = false
	continue_button.visible = false
	complete_chapter_button.visible = false

func _on_continue_button_pressed() -> void:
	hide_screen()

func _on_complete_chapter_button_pressed() -> void:
	hide_screen()
	HudEvents.chapter_completed.emit()
