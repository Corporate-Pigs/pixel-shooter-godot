extends CenterContainer

@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _process(delta: float) -> void:
	var score = ScoreSystem.get_top_score_value()
	score_label.text = str(score)
