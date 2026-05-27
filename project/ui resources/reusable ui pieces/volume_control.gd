extends HBoxContainer

@export_group("Who do I control")
@export var music_controller:bool = false
@export var sounds_controller:bool = false
@onready var music_object:Object = BackgroundMusicPlayer
@onready var sounds_object:Object = AudioEvents
var my_audio_object:Object

@export_group("Initialization Parameters")
@export var red_x:TextureRect
@export var slider:HSlider

func _ready() -> void:
	if not music_controller and not sounds_controller:
		push_error("volume slider not assigned to music or sounds")
	if music_controller and sounds_controller:
		push_error("volume slider assigned to both music and sounds")
	
	if music_controller: my_audio_object = music_object
	if sounds_controller: my_audio_object = sounds_object
	
	red_x.visible = false
	slider.value = my_audio_object.get_current_volume() * 100

func _on_volume_slider_value_changed(new_slider_value: float) -> void:
	my_audio_object.change_volume(new_slider_value/100)

func _on_genre_icon_pressed() -> void:
	BackgroundMusicPlayer.flip_genre()

func _on_shuffle_icon_pressed() -> void:
	BackgroundMusicPlayer.shuffle_playlist()

func _on_label_mute_button_pressed() -> void:
	red_x.visible = !red_x.visible
	
	if red_x.visible:
		disable_slider()
		mute(my_audio_object)
	
	elif not red_x.visible:
		enable_slider()
		unmute(my_audio_object)

func mute(target_object:Object) -> void:
	target_object.change_volume(0)

func unmute(_target_object:Object) -> void:
	slider.value_changed.emit(slider.value) #dummy signal to re-check current value, which should set volume

func disable_slider() -> void:
	slider.editable = false
	slider.modulate = Color(0.3,0.3,0.3,1)

func enable_slider() -> void:
	slider.editable = true
	slider.modulate = Color(1,1,1,1)
