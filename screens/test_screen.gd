extends CanvasLayer


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_save_button_button_up() -> void:
	const k_score = 999999
	ScoreSystem.add_or_update_score("test", k_score)
	assert(ScoreSystem.get_top_score_value() == k_score + 1)
