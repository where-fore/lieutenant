extends Node2D

#generally for audio effects:
#if playing regularly, but not overlapping: create a dedicated child audio stream player in the parent scene, and call it to play
#if a one-shot sound that needs to be able to overlap: create a PackedScene of the audio stream player, and call to instantiate and play it

@onready var new_day_crow_sfx_player:AudioStreamPlayer = $NewDayCrow
@export var button_click:PackedScene

var varied_pitch_range:float = 0.1

func _ready() -> void:
	TimeOfDay.new_day.connect(new_day)
	AudioEvents.generic_button_pressed.connect(click_ui_button)
	
	
	if varied_pitch_range > 0.5 or varied_pitch_range <= 0 or not varied_pitch_range:
		push_error("pitch range set incorrectly. currently: ", varied_pitch_range)

func new_day() -> void:
	play_sound(new_day_crow_sfx_player)

func click_ui_button() -> void:
	play_sound(button_click, true)

func play_sound(player_or_scene:Variant, vary_pitch:bool = false) -> void:
	if player_or_scene is AudioStreamPlayer:
		if vary_pitch: player_or_scene.pitch_scale = randf_range(1-varied_pitch_range, 1+varied_pitch_range)
		_play_sound_on_target_player(player_or_scene)
	
	elif player_or_scene is PackedScene:
		var new_player:AudioStreamPlayer = _create_instanced_one_shot(player_or_scene)
		if vary_pitch: new_player.pitch_scale = randf_range(1-varied_pitch_range, 1+varied_pitch_range)
		_play_sound_on_target_player(new_player)
	
	else: push_error("tried to play sound but didn't get a valid type: ", player_or_scene.name)

func _create_instanced_one_shot(target_instance:PackedScene) -> AudioStreamPlayer:
	var new_audio_player:AudioStreamPlayer = target_instance.instantiate()
	add_child(new_audio_player)
	return new_audio_player

func _play_sound_on_target_player(target_player:AudioStreamPlayer) -> void:
	target_player.play()
