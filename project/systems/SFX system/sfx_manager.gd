extends Node2D

@onready var new_day_crow_sfx_player:AudioStreamPlayer = $NewDayCrow

func _ready() -> void:
	TimeOfDay.new_day.connect(new_day)

func new_day() -> void:
	play_sound_varied_pitch_dedicated_one_shot(new_day_crow_sfx_player)

func play_sound_dedicated_one_shot(target_player:AudioStreamPlayer) -> void:
	target_player.play()

func play_sound_varied_pitch_dedicated_one_shot(target_player:AudioStreamPlayer) -> void:
	target_player.pitch_scale = randf_range(0.9, 1.1)
	target_player.play()
