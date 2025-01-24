extends CanvasLayer

@onready var player_1_spaceship: Spaceship = $Player1Spaceship

@onready var player_1_info_hud: CenterContainer = $HeaderContainer/HBoxContainer/TopLeftContainer/Player1InfoHud
@onready var player_2_info_hud: CenterContainer = $HeaderContainer/HBoxContainer/TopRightContainer/Player2InfoHud

@onready var huds_per_player = [player_1_info_hud, player_2_info_hud]
@onready var lifes_per_player = [3, 3]
@onready var players = [player_1_spaceship]

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

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
		players[player_index].respawn(3)
