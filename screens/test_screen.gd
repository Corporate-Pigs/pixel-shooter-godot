extends CanvasLayer


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_save_button_button_up() -> void:
	ScoreSystem.add_or_update_score("test", 1337)
