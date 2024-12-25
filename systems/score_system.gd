extends Node

const k_max_entries = 10
const k_save_file_path = "./saved_data.save"

var global_hi_scores = {
	"Player1": 1000,
	"Player2": 2000,
	"Player3": 1500,
	"Player4": 3000
}

func _sort_by_score(a, b, hi_scores) -> bool:
	return hi_scores[a] < hi_scores[b] 

func sort_scores_by_value() -> void:
	pass
	#global_hi_scores.sort_custom(self, "_sort_by_value", global_hi_scores)

func truncate_map(max_entries: int) -> void:
	if global_hi_scores.size() < max_entries:
		return

	var truncated_map = {}
	for i in range(min(max_entries, global_hi_scores.size())):
		var key = global_hi_scores[i]
		truncated_map[key] = global_hi_scores[key]
	global_hi_scores = truncated_map

func _ready() -> void:
	var loaded_hi_scores = JSON.parse_string(SaveSystem.load_file(k_save_file_path))
	if loaded_hi_scores == null:
		return
	
	global_hi_scores = loaded_hi_scores
	sort_scores_by_value()
	truncate_map(k_max_entries)

func add_or_update_score(player: String, score: int) -> void:
	global_hi_scores[player] = score
	sort_scores_by_value()
	truncate_map(k_max_entries)
	SaveSystem.save_file(k_save_file_path, global_hi_scores)

func get_top_score_value() -> int:
	var top_score = 0
	for key in global_hi_scores.keys():
		top_score = max(top_score, global_hi_scores[key])
	return top_score
