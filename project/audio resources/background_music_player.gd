extends AudioStreamPlayer

@export var starting_track:AudioStream
@export var tracks:Array[AudioStream]

var current_track_index:int

func start_music() -> void:
	tracks.shuffle()
	tracks.push_front(starting_track)
	
	self.stream = starting_track
	self.play(2.3) #magic number, it's the dead air at start of the track i chose (dead air there for looping's sake)

func play_next_track() -> void:
	current_track_index += 1
	
	var playlist_size:int = tracks.size()
	if current_track_index > playlist_size - 1:
		shuffle_playlist(tracks[current_track_index])
		current_track_index = 0
	
	self.stream = tracks[current_track_index]
	self.play()

func shuffle_playlist(current_track:AudioStream) -> void:
	while tracks[0] == current_track or tracks[1] == current_track:
		tracks.shuffle()

func _on_finished() -> void:
	play_next_track()

func change_volume(new_slider_percent:float) -> void:
	var bus_name:StringName = self.bus
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_slider_percent))
