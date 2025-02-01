extends CanvasLayer

@export var next_scene: PackedScene

@onready var char_selection_subscreen: CharSelectionSubscreen = $MarginContainer/VSplitContainer/AspectRatioContainer/CharSelectionSubscreen
@onready var paralax_scene: ParalaxBackground = $ParalaxScene
@onready var title_label: Label = $MarginContainer/VSplitContainer/TitleLabel
@onready var starting_timer: Timer = $StartingTimer

var level_scene: LevelScreen

func _on_char_selection_subscreen_on_char_selected(_selected_char_id: int) -> void:
	title_label.text = "Starting"
	paralax_scene.set_paralax_speed_factor(2)
	starting_timer.start()
	ScoreSystem.player_characters[0] = _selected_char_id

func _on_starting_timer_timeout() -> void:
	get_tree().change_scene_to_packed(next_scene)
	
