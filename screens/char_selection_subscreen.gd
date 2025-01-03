extends Node2D

class_name CharSelectionSubscreen

@onready var right_projectile_sprite_2d: Sprite2D = $HBoxContainer/VBoxContainer/CenterContainer/Node2D/Projectiles/RightProjectileSprite2D
@onready var left_projectile_sprite_2d: Sprite2D = $HBoxContainer/VBoxContainer/CenterContainer/Node2D/Projectiles/LeftProjectileSprite2D
@onready var character_sprite_2d: Sprite2D = $HBoxContainer/VBoxContainer/HSplitContainer/CenterContainer/CharacterSprite2D
@onready var character_name_label: Label = $HBoxContainer/VBoxContainer/HSplitContainer/CharacterNameLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flame_animation_player: AnimationPlayer = $FlameAnimationPlayer
@onready var flame_sprite_2d: Sprite2D = $HBoxContainer/VBoxContainer/CenterContainer/Node2D/Node2D/FlameSprite2D
@onready var projectiles: Node2D = $HBoxContainer/VBoxContainer/CenterContainer/Node2D/Projectiles
@onready var left_selector_sprite_2d: Sprite2D = $HBoxContainer/LeftSelector/LeftSelectorSprite2D
@onready var right_selector_sprite_2d: Sprite2D = $HBoxContainer/RightSelector/RightSelectorSprite2D

var _is_selected: bool = false
var _k_animation_name: String = "selection"
var _k_flame_animation_name: String = "flame"
var _selected_character: int = 0

signal on_char_selected(selected_char_id: int)
signal on_char_unselected()

func get_selected_character() -> int:
	return _selected_character

func _start_animation(animation: AnimationPlayer, animation_name: String) -> void:
	animation.seek(0, true)
	animation.play(animation_name)

func _stop_animation(animation: AnimationPlayer) -> void:
	animation.seek(0, true)
	animation.stop()

func _next_character() -> void:
	_selected_character = (_selected_character + 1) % len(Constants.k_characters)
	_update_sprites()

func _previous_character() -> void:
	_selected_character = _selected_character - 1
	if _selected_character < 0:
		_selected_character = len(Constants.k_characters) - 1
	_update_sprites()

func _update_animation_track_keyframes() -> void:
	var animation: Animation = animation_player.get_animation(_k_animation_name)
	var track_count = animation.get_track_count()
	var char_info = Constants.k_characters[_selected_character]
	for track_index in range(track_count):
		var track_path = str(animation.track_get_path(track_index))

		# haven't found a better way of updating frame coords
		if "CharacterSprite2D:frame_coords" in track_path:
			var keyframe_count = animation.track_get_key_count(track_index)
			for keyframe_index in range(keyframe_count):
				var keyframe_value = animation.track_get_key_value(track_index, keyframe_index)
				keyframe_value.y = char_info._sprite_row
				animation.track_set_key_value(track_index, keyframe_index, keyframe_value)

		elif "ShipSprite2D:frame_coords" in track_path:
			var keyframe_count = animation.track_get_key_count(track_index)
			for keyframe_index in range(keyframe_count):
				var keyframe_value = animation.track_get_key_value(track_index, keyframe_index)
				keyframe_value.y = char_info._ship_row
				animation.track_set_key_value(track_index, keyframe_index, keyframe_value)

func _update_projectiles() -> void:
	var char_info = Constants.k_characters[_selected_character]
	right_projectile_sprite_2d.frame = char_info._shot_frame
	left_projectile_sprite_2d.frame = char_info._shot_frame

func _update_char_name() -> void:
	var char_info = Constants.k_characters[_selected_character]
	character_name_label.text = char_info._name

func _update_sprites() -> void:
	_update_animation_track_keyframes()
	_update_projectiles()
	_update_char_name()

func _select_character() -> void:
	_start_animation(flame_animation_player, _k_flame_animation_name)
	_stop_animation(animation_player)
	emit_signal("on_char_selected", _selected_character)
	projectiles.visible = false
	flame_sprite_2d.visible = true
	_is_selected = true
	left_selector_sprite_2d.modulate.a = 0
	right_selector_sprite_2d.modulate.a = 0

func _deselect_character() -> void:
	_stop_animation(flame_animation_player)
	_start_animation(animation_player, _k_animation_name)
	emit_signal("on_char_unselected")
	projectiles.visible = true
	flame_sprite_2d.visible = false
	_is_selected = false
	left_selector_sprite_2d.modulate.a = 1
	right_selector_sprite_2d.modulate.a = 1

func _ready() -> void:
	flame_sprite_2d.visible = false
	animation_player.play(_k_animation_name)

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed(Constants.k_left) and not _is_selected:
		_previous_character()
	elif Input.is_action_just_pressed(Constants.k_right) and not _is_selected:
		_next_character()
	elif Input.is_action_just_pressed(Constants.k_action) and not _is_selected:
		_select_character()
	elif Input.is_action_just_pressed(Constants.k_back) and _is_selected:
		_deselect_character()
