extends Panel

@onready var label:RichTextLabel = $RichTextLabel

var delay_before_fading:float = 1.5
var fade_duration:float = 3
var typewriter_characters_per_second:int = 8

func _ready() -> void:
	TimeOfDay.new_day.connect(basic_new_day_message)
	
	label.text = ""
	self.modulate = Color(0,0,0,0)
	
	visible = true

func basic_new_day_message() -> void:
	scroll_text("A new dawn rises...")

func scroll_text(new_text:String) -> void:
	label.visible_characters = 0
	self.modulate = Color(1,1,1,1)
	
	label.text = new_text
	
	var total_characters:int = label.get_total_character_count()
	var duration:float = total_characters / typewriter_characters_per_second
	
	var visible_characters_tween:Tween = create_tween()
	visible_characters_tween.tween_property(label, "visible_characters", total_characters, duration)
	
	await visible_characters_tween.finished
	await get_tree().create_timer(delay_before_fading).timeout
	_fade_text()

func _fade_text() -> void:
	var visibility_tween:Tween = create_tween()
	visibility_tween.set_trans(Tween.TRANS_QUINT)
	visibility_tween.set_ease(Tween.EASE_IN)
	visibility_tween.tween_property(self, "modulate", Color(0,0,0,0), fade_duration)
