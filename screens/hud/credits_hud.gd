extends CenterContainer

@export var player_number: int = 1
@onready var credits_score_label: Label = $VBoxContainer/CreditsScoreLabel

func _process(_delta: float) -> void:
	credits_score_label.text = "Credits " + str(ScoreSystem.get_credit_to_player(player_number))
