extends Node

signal generic_button_pressed

var default_volume:float = 0.60
var muted:bool = false

func _ready() -> void:
	change_volume(default_volume)
	
	#grab all current and future buttons and connect their signals
	#this seems like expensive and unwieldy overhead
	#but it is a creative way to not need to change every single button to a new scene
	#but i'll probably want them to be a new scene at some point, to change focus modes and stuff
	
	get_tree().node_added.connect(setup_button_signal)
	_hook_existing_buttons(get_tree().root)

func setup_button_signal(node_added:Node) -> void:
	if node_added is BaseButton:
		_connect_button_signal(node_added)

func signal_button_sound() -> void:
	generic_button_pressed.emit()

func _hook_existing_buttons(node_to_check:Node) -> void:
	if node_to_check is BaseButton:
		_connect_button_signal(node_to_check)
	
	for child:Node in node_to_check.get_children():
		_hook_existing_buttons(child)

func _connect_button_signal(button_node:BaseButton) -> void:
	button_node.pressed.connect(signal_button_sound)

func change_volume(new_slider_percent:float) -> void:
	var bus_name:StringName = "SFX"
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_slider_percent))

func get_current_volume() -> float:
	var bus_name:StringName = "SFX"
	var bus_index:int = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_linear(bus_index)
