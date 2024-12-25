extends Node

func save_file(file_path: String, data) -> void:
	var file_access := FileAccess.open(file_path, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
		
	var json_data := JSON.stringify(data)
	file_access.store_line(json_data)
	file_access.close()

func load_file(file_path: String) -> String:
	if not FileAccess.file_exists(file_path):
		print("An error happened while load data: file '" + file_path + "' not found")
		return JSON.stringify(null)
	
	var file_access := FileAccess.open(file_path, FileAccess.READ)
	var json_data := file_access.get_line()
	file_access.close()
	return json_data
