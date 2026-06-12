extends AudioStreamPlayer

@export var starting_classical_track:AudioStream
@export var classical_tracks:Array[AudioStream]
@export var starting_pixel_track:AudioStream
@export var pixel_tracks:Array[AudioStream]

enum Genre {CLASSICAL, PIXEL}
var current_genre:int
var current_track_index:int
var current_playlist:Array[AudioStream]

var default_volume:float = 0.60
var muted:bool = false

func _ready() -> void:
	#preload this stuff, so no hiccups in game
	classical_tracks.shuffle()
	classical_tracks.push_front(starting_classical_track)
	pixel_tracks.shuffle()
	pixel_tracks.push_front(starting_pixel_track)
	
	current_genre = Genre.CLASSICAL
	set_starting_track()
	
	preload_track()
	
	change_volume(default_volume)

func begin_music() -> void:
	if not playing:
		start_music()

func start_classical_music() -> void:
	if current_genre == Genre.CLASSICAL:
		if not playing:
			start_music()
	else:
		current_genre = Genre.CLASSICAL
		set_starting_track()
		start_music()

func start_pixel_music() -> void:
	if current_genre == Genre.PIXEL:
		if not playing:
			start_music()
	else:
		current_genre = Genre.PIXEL
		set_starting_track()
		start_music()

func set_starting_track() -> void:
	if current_genre == Genre.CLASSICAL:
		self.stream = starting_classical_track
	elif current_genre == Genre.PIXEL:
		self.stream = starting_pixel_track

func flip_genre() -> void:
	if current_genre == Genre.PIXEL:
		start_classical_music()
	elif current_genre == Genre.CLASSICAL:
		start_pixel_music()

func start_music() -> void:
	var starting_delay:float
	
	if current_genre == Genre.CLASSICAL:
		current_playlist = classical_tracks
		starting_delay = 2.1 #magic number, it's the dead air at start of the track i chose (dead air there for looping's sake)
		
	elif current_genre == Genre.PIXEL:
		current_playlist = pixel_tracks
		starting_delay = 0.1 #magic number, it's the dead air at start of the track i chose (dead air there for looping's sake)
	
	else: push_error("tried to start music before selecting genre")
	
	self.play(starting_delay)

func play_next_track() -> void:
	current_track_index += 1
	
	var playlist_size:int = current_playlist.size()
	if current_track_index > playlist_size - 1:
		shuffle_playlist()
		current_track_index = 0
	
	self.stream = current_playlist[current_track_index]
	self.play()

func shuffle_playlist() -> void:
	if self.playing:
		current_playlist.shuffle()
		#note this checks 1, because i'm going to go to 0, then next track so 0+1=1
		while current_playlist[1] == self.stream: current_playlist.shuffle()
		current_track_index = 0
		play_next_track()

func _on_finished() -> void:
	play_next_track()

func change_volume(new_slider_percent:float) -> void:
	var bus_name:StringName = self.bus
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_slider_percent))

func get_current_volume() -> float:
	var bus_name:StringName = self.bus
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_linear(bus_index)

func preload_track() -> void:
	self.volume_db = -120 #inaudible
	self.play()
	await get_tree().create_timer(0.1).timeout
	self.stop()
	self.volume_db = 0 #default
