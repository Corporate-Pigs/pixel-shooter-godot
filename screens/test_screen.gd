extends Node2D

func _on_inc_score_player_1_button_pressed() -> void:
	var player_number = 1
	var current_hi_score = ScoreSystem.get_hi_score_for_player_number(player_number)
	ScoreSystem.set_hi_score_for_player_number(player_number, current_hi_score + 100)

func _on_save_button_pressed() -> void:
	const k_score = 999999
	ScoreSystem.add_or_update_score("test", k_score)
	assert(ScoreSystem.get_top_score_value() == k_score)
