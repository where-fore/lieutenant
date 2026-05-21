extends Resource
class_name ThresholdBehaviour

var parent_combatant:Combatant
var threshold_dictionary:Dictionary[StringName, int]
var active:bool = false
signal state_changed(behaviour:ThresholdBehaviour)


func setup(new_parent_combatant:Combatant, new_threshold_dictionary:Dictionary[StringName, int]) -> void:
	parent_combatant = new_parent_combatant
	parent_combatant.stats_updated.connect(check_thresholds)
	threshold_dictionary = new_threshold_dictionary
	
	check_thresholds()

func check_thresholds() -> void:
	var passed_thresholds:int = 0
	var needed_to_pass:int = threshold_dictionary.size()
		#note this requires all thresholds in the dictionary to pass
	
	for threshold:StringName in threshold_dictionary:
		if parent_combatant.current_stats[threshold] >= threshold_dictionary[threshold]:
				#note the >=, meets it beats it
			passed_thresholds += 1
	
	if passed_thresholds == needed_to_pass:
		if not active: _activate_threshold()
	elif passed_thresholds < needed_to_pass:
		if active: _deactivate_threshold()
	else:
		push_error("got confused checking thresholds: ", passed_thresholds, " thresholds passed, but i needed ", needed_to_pass, " to pass. full dictionary: ", threshold_dictionary)

func _activate_threshold() -> void:
	active = true
	_emit_update()

func _deactivate_threshold() -> void:
	active = false
	_emit_update()

func _emit_update() -> void:
	state_changed.emit(self)
