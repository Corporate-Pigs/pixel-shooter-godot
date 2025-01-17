extends CharacterBody2D

class_name Spaceship

@onready var ship_sprite_2d: Sprite2D = $Node2D/ShipSprite2D

@onready var shot_node_2d_0: Node2D = $ShotNodes/ShotNode2D0
@onready var shot_node_2d_1: Node2D = $ShotNodes/ShotNode2D1
@onready var shot_node_2d_2: Node2D = $ShotNodes/ShotNode2D2
@onready var shot_node_2d_3: Node2D = $ShotNodes/ShotNode2D3
@onready var shot_node_2d_4: Node2D = $ShotNodes/ShotNode2D4
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var shot_nodes = [
	shot_node_2d_0, 
	shot_node_2d_1, 
	shot_node_2d_2, 
	shot_node_2d_3, 
	shot_node_2d_4
]

@export var player_number: int = 1
@export var selected_character: int = 0
@export var speed: int = 500
@export var shots_per_second: int = 1
@export var projectile_prefab: PackedScene

var _char_info = Constants.k_characters[selected_character]
var _shots_per_level = [1, 3, 5]
var _time_since_shot: float = 0
var _time_per_shot: float = 1
var _level: int = 0
var _max_level: int = 2
var _current_score: int = 0

var _k_flame_animation_name: String = "flame"

func _getMovementDirectionFromInput() -> Vector2:
	var verticalInput = Input.get_axis("up", "down")
	var horizontalInput = Input.get_axis("left", "right")
	return Vector2(horizontalInput, verticalInput)

func _moveInDirection(direction: Vector2) -> KinematicCollision2D:
	var velocity = Vector2.ZERO
	if direction == Vector2.ZERO:
		return null
	velocity = direction * speed
	return move_and_collide(velocity)

func _animateMovement(direction: Vector2) -> void:
	ship_sprite_2d.frame_coords.x = 1 + int(direction.x)

func _setup_collision_layer_for_player_number() -> void:
	var layer_mask = 1
	if player_number == 1:
		layer_mask = 2
	collision_layer &= layer_mask

func _ready() -> void:
	_char_info = Constants.k_characters[selected_character]
	_time_per_shot = 1 / float(shots_per_second)
	animation_player.play(_k_flame_animation_name)
	_setup_collision_layer_for_player_number()

func _process(delta: float) -> void:
	ship_sprite_2d.frame_coords.y = _char_info._ship_row
	_time_since_shot += delta
	if Input.is_action_pressed("action") and _time_since_shot > _time_per_shot:
		_shoot()
		_time_since_shot = 0

func _physics_process(delta: float) -> void:
	var movementDirection = _getMovementDirectionFromInput()
	_animateMovement(movementDirection)
	var collision = _moveInDirection(movementDirection.normalized() * delta)
	_check_for_collisions(collision)

func _shoot() -> void:
	var root_scene = get_tree().root.get_child(3)
	var projectiles_layer_node = root_scene.get_node("ProjectilesLayer")
	var n_shots = _shots_per_level[_level]
	for node in shot_nodes:
		var projectile: Projectile = projectile_prefab.instantiate() as Projectile
		projectile.initialize(_char_info._ship_row, player_number)
		var shoot_position = node.global_position
		projectile.global_position = shoot_position
		projectiles_layer_node.add_child(projectile)
		
		n_shots -= 1
		if n_shots == 0:
			return	

func _check_for_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return
	
	var collider = collision.get_collider()
	if collider is PowerUp:
		_current_score += collider.points
		_level = min(_max_level, _level + collider.levels)
		ScoreSystem.set_current_score_for_player_number(player_number, _current_score)
		collider.take()
		return
