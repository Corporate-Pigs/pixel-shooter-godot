extends CenterContainer

@export var player_number = 1
@export var sprite_number = 1
@export var is_online = false
@export var is_on_gameover = false
@export var show_hi_score = true
@export var show_lifes = true
@export var show_specials = true
@export var ship_sprites: Sprite2D

@onready var player_label: Label = $VBoxContainer/PlayerLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel

@onready var container_lives: HBoxContainer = $VBoxContainer/HBoxContainer/ContainerLives
@onready var container_specials: HBoxContainer = $VBoxContainer/HBoxContainer/ContainerSpecials

@onready var life_1_sprite_2d: Sprite2D = $VBoxContainer/HBoxContainer/ContainerLives/Container/Life1Sprite2D
@onready var life_2_sprite_2d: Sprite2D = $VBoxContainer/HBoxContainer/ContainerLives/Container2/Life2Sprite2D
@onready var life_3_sprite_2d: Sprite2D = $VBoxContainer/HBoxContainer/ContainerLives/Container3/Life3Sprite2D
@onready var sprites = [life_1_sprite_2d, life_2_sprite_2d, life_3_sprite_2d]

func _ready() -> void:
	player_label.text = "Player-" + str(player_number)
	score_label.modulate.a = 1 if is_online else 0
	container_lives.modulate.a = 1 if show_lifes and is_online else 0
	container_specials.modulate.a = 1 if show_specials and is_online else 0

func _process(_delta: float) -> void:
	var score = 0
	if show_hi_score:
		score = ScoreSystem.get_hi_score_for_player_number(player_number)
	else:
		score = ScoreSystem.get_current_score_for_player_number(player_number)
	score_label.text = str(score)

func set_lifes(lifes: int) -> void:
	for sprite in sprites:
		sprite.modulate.a = 0
	
	for i in lifes:
		sprites[i].modulate.a = 1
