extends CanvasLayer

@export var power_up_prefab: PackedScene
@export var power_up_drop_rate: float = 0.5

@onready var player_1_spaceship: Spaceship = $Player1Spaceship
@onready var power_up_layer: Node2D = $PowerUpLayer
@onready var player_1_info_hud: CenterContainer = $HeaderContainer/HBoxContainer/TopLeftContainer/Player1InfoHud
@onready var player_2_info_hud: CenterContainer = $HeaderContainer/HBoxContainer/TopRightContainer/Player2InfoHud
@onready var huds_per_player = [player_1_info_hud, player_2_info_hud]
@onready var lifes_per_player = [3, 3]
@onready var players = [player_1_spaceship]
@onready var game_over_hud: GameOverHud = $GameOverHud

var is_on_gameover_countdown: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var player_index = 0
	if is_on_gameover_countdown and Input.is_action_pressed(Constants.k_start):
		players[player_index].respawn(0)
		is_on_gameover_countdown = false
		lifes_per_player[player_index] = 3
		game_over_hud.stop_count_down()

func _on_despawners_body_entered(body: Node2D) -> void:
	if body is Projectile:
		body.hit()
	elif body is Enemy:
		body.despawn()

func _on_spaceship_exploded(player_number: int) -> void:
	var player_index = player_number - 1
	lifes_per_player[player_index] -= 1
	huds_per_player[player_index].set_lifes(lifes_per_player[player_index])
	if lifes_per_player[player_index] > 0:
		players[player_index].respawn(2)
	else:
		game_over_hud.start_count_down()
		is_on_gameover_countdown = true

func _on_enemy_destroyed(position: Vector2, player_number: int) -> void:
	if players[player_number - 1]._level < 2 and randf() > power_up_drop_rate:
		var power_up = power_up_prefab.instantiate()
		power_up.global_position = position
		power_up_layer.add_child(power_up)

func _on_game_over() -> void:
	
