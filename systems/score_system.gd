extends Node

const k_max_entries = 10
const k_save_file_path = "./saved_data.save"

var global_hi_scores = {
	"Player1": 1000,
	"Player2": 2000,
	"Player3": 1500,
	"Player4": 3000
}

var session_hi_scores_per_player = [0, 0]
var session_current_game_scores_per_player = [0, 0]
var credits_per_player = [0, 0]

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

func _get_index_from_player_number(player_number: int) -> int:
	return max(0, min(1, player_number-1))

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

func get_hi_score_for_player_number(player_number: int) -> int:
	var index = _get_index_from_player_number(player_number)
	return session_hi_scores_per_player[index]

func set_hi_score_for_player_number(player_number: int, score: int) -> void:
	var index = _get_index_from_player_number(player_number)
	session_hi_scores_per_player[index] = score

func get_current_score_for_player_number(player_number: int) -> int:
	var index = _get_index_from_player_number(player_number)
	return session_current_game_scores_per_player[index]

func set_current_score_for_player_number(player_number: int, score: int) -> void:
	var index = _get_index_from_player_number(player_number)
	session_current_game_scores_per_player[index] = score

func add_credit_to_player(player_number: int) -> void:
	var index = _get_index_from_player_number(player_number)
	credits_per_player[index] += 1
	
func get_credit_to_player(player_number: int) -> int:
	var index = _get_index_from_player_number(player_number)
	return credits_per_player[index]
