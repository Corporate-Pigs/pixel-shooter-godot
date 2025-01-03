extends CanvasLayer

@export var p1_next_scene: PackedScene
@export var p2_next_scene: PackedScene

@onready var _1_player_sprite_2d: Sprite2D = $"FooterContainer/VBoxContainer/VBoxContainer/1PlayerContainer/Container/1PlayerSprite2D"
@onready var _2_players_sprite_2d: Sprite2D = $"FooterContainer/VBoxContainer/VBoxContainer/2PlayersContainer/Container/2PlayersSprite2D"

@onready var press_start_label: Label = $FooterContainer/VBoxContainer/VBoxContainer/MarginContainer/CenterContainer/PressStartLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var number_of_players: int = 1

func _select_player_number(number: int) -> void:
	if number == 2:
		_1_player_sprite_2d.visible = false
		_2_players_sprite_2d.visible = true
		number_of_players = 2
	else:
		_1_player_sprite_2d.visible = true
		_2_players_sprite_2d.visible = false
		number_of_players = 1

func _ready() -> void:
	_2_players_sprite_2d.visible = false
	animation_player.play("press_start")

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed(Constants.k_start):
		if number_of_players == 2:
			get_tree().change_scene_to_packed(p2_next_scene)
		else:
			get_tree().change_scene_to_packed(p1_next_scene)
		return
		
	if Input.is_action_just_pressed(Constants.k_up):
		_select_player_number(1)
	elif Input.is_action_just_pressed(Constants.k_down):
		_select_player_number(2)
		
	if Input.is_action_just_pressed(Constants.k_insert_coin):
		ScoreSystem.add_credit_to_player(1)
		ScoreSystem.add_credit_to_player(2)
