extends Node

#this is currently unused, i'll probably return to this for save and loading?

func read_json(json_file_path:String) -> Variant:
	var file:FileAccess = FileAccess.open(json_file_path, FileAccess.READ)
	if not file:
		push_error("could not open json file at specified path: " + json_file_path)
		return null
	var file_as_text:String = file.get_as_text()
	file.close()
	
	var json_object:JSON = JSON.new()
	var json_error_type:Error = json_object.parse(file_as_text)
	if json_error_type == OK:
		return json_object.data
	else:
		push_error("JSON Error: " + str(json_object.get_error_message()) + " at line " + str(json_object.get_error_line()))
		return null
