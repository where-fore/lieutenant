extends AudioStreamPlayer

@export var starting_classical_track:AudioStream
@export var classical_tracks:Array[AudioStream]
@export var starting_pixel_track:AudioStream
@export var pixel_tracks:Array[AudioStream]

enum Genre {CLASSICAL, PIXEL}
var current_genre:int
var current_track_index:int
var current_playlist:Array[AudioStream]

func start_classical_music() -> void:
	current_genre = Genre.CLASSICAL
	start_music()

func start_pixel_music() -> void:
	current_genre = Genre.PIXEL
	start_music()

func flip_genre() -> void:
	if current_genre == Genre.PIXEL:
		start_classical_music()
	elif current_genre == Genre.CLASSICAL:
		start_pixel_music()

func start_music() -> void:
	var starting_delay:float
	
	if current_genre == Genre.CLASSICAL:
		classical_tracks.shuffle()
		classical_tracks.push_front(starting_classical_track)
		current_playlist = classical_tracks
		starting_delay = 2.3
		self.stream = starting_classical_track
		
	elif current_genre == Genre.PIXEL:
		pixel_tracks.shuffle()
		pixel_tracks.push_front(starting_pixel_track)
		current_playlist = pixel_tracks
		starting_delay = 0.1
		self.stream = starting_pixel_track
	
	else: push_error("tried to start music before selecting genre")
	
	self.play(starting_delay) #magic number, it's the dead air at start of the track i chose (dead air there for looping's sake)

func play_next_track() -> void:
	current_track_index += 1
	
	var playlist_size:int = current_playlist.size()
	if current_track_index > playlist_size - 1:
		shuffle_playlist(current_playlist[current_track_index])
		current_track_index = 0
	
	self.stream = current_playlist[current_track_index]
	self.play()

func shuffle_playlist(current_track:AudioStream) -> void:
	while current_playlist[0] == current_track or current_playlist[1] == current_track:
		current_playlist.shuffle()

func _on_finished() -> void:
	play_next_track()

func change_volume(new_slider_percent:float) -> void:
	var bus_name:StringName = self.bus
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_slider_percent))
