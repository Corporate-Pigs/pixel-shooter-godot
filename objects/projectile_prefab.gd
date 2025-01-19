extends Area2D

class_name Projectile

@onready var sprite_2d: Sprite2D = $Sprite2D

var _shot_frame: int = 0
var _player_number: int = 0
var _move_speed: Vector2 = Vector2.ZERO
var _damage: int = 1

func initialize(shot_frame: int, player_number: int, move_speed: Vector2, damage: int) -> void:
	_shot_frame = shot_frame
	_player_number = player_number
	_move_speed = move_speed
	_damage = damage
	
	# enemy projectile
	if player_number == 0:
		collision_layer = Constants.k_enemy_shot_layer
		collision_mask = Constants.k_player_1_layer and Constants.k_player_2_layer
		
	# player 1 projectile
	elif player_number == 1:
		collision_layer = Constants.k_player_1_shot_layer
		collision_mask = Constants.k_enemy_layer
		
	# player 2 projectile
	elif player_number == 2:
		collision_layer = Constants.k_player_2_shot_layer
		collision_mask = Constants.k_enemy_layer

func _ready() -> void:
	sprite_2d.frame = _shot_frame

func _physics_process(delta: float) -> void:
	position += _move_speed * delta

func is_from_player() -> bool:
	return _player_number > 0

func hit() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.hit()

func _on_area_entered(area: Area2D) -> void:
	area.hit(self)
