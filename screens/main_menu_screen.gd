extends CanvasLayer

@onready var _1_player_sprite_2d: Sprite2D = $"FooterContainer/VBoxContainer/VBoxContainer/HSplitContainer/Container/1PlayerSprite2D"
@onready var _2_players_sprite_2d: Sprite2D = $"FooterContainer/VBoxContainer/VBoxContainer/HSplitContainer2/Container/2PlayersSprite2D"
@onready var press_start_label: Label = $FooterContainer/VBoxContainer/VBoxContainer/MarginContainer/CenterContainer/PressStartLabel

@export var next_scene: PackedScene
@export var press_start_blink_period: int = 1

var number_of_players: int = 1
var time_since_last_blink: float = 0
var press_start_alfa: float = 1

func _select_player_number(number: int) -> void:
	if number == 2:
		_1_player_sprite_2d.visible = false
		_2_players_sprite_2d.visible = true
		number_of_players = 2
	else:
		_1_player_sprite_2d.visible = true
		_2_players_sprite_2d.visible = false
		number_of_players = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_2_players_sprite_2d.visible = false

func _update_press_start_label(delta: float) -> void:
	time_since_last_blink += delta
	if time_since_last_blink < press_start_blink_period:
		return

	time_since_last_blink = 0
	if press_start_alfa == 1:
		press_start_alfa = 0
	else:
		press_start_alfa = 1
	press_start_label.self_modulate.a = press_start_alfa

func _process(delta: float) -> void:
	_update_press_start_label(delta)

	if Input.is_action_pressed(InputConstants.k_up):
		_select_player_number(1)
	elif Input.is_action_pressed(InputConstants.k_down):
		_select_player_number(2)
