extends CanvasLayer

@export var next_scene: PackedScene

@onready var char_selection_subscreen: CharSelectionSubscreen = $MarginContainer/VSplitContainer/AspectRatioContainer/CharSelectionSubscreen
@onready var paralax_scene: ParalaxBackground = $ParalaxScene
@onready var title_label: Label = $MarginContainer/VSplitContainer/TitleLabel

func _on_char_selection_subscreen_on_char_selected(selected_char_id: int) -> void:
	title_label.text = "Starting"
	paralax_scene.set_paralax_speed_factor(2)
	get_tree().change_scene_to_packed(next_scene)
