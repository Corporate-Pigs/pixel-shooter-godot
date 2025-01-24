extends CharacterBody2D

class_name Spaceship

@onready var sprites_node_2d: Node2D = $Node2D
@onready var explosion_nodes: Node2D = $Explosion
@onready var ship_sprite_2d: Sprite2D = $Node2D/ShipSprite2D
@onready var shot_node_2d_0: Node2D = $ShotNodes/ShotNode2D0
@onready var shot_node_2d_1: Node2D = $ShotNodes/ShotNode2D1
@onready var shot_node_2d_2: Node2D = $ShotNodes/ShotNode2D2
@onready var shot_node_2d_3: Node2D = $ShotNodes/ShotNode2D3
@onready var shot_node_2d_4: Node2D = $ShotNodes/ShotNode2D4
@onready var flame_animation_player: AnimationPlayer = $AnimationPlayer
@onready var explode_animation_player: AnimationPlayer = $Explosion/AnimationPlayer
@onready var respawn_timer: Timer = $RespawnTimer
@onready var invulnerable_timer: Timer = $InvulnerableTimer

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

signal exploded(player_number: int)

var _char_info = Constants.k_characters[selected_character]
var _shots_per_level = [1, 3, 5]
var _time_since_shot: float = 0
var _time_per_shot: float = 1
var _level: int = 0
var _max_level: int = 2
var is_destroyed: bool = false
var is_invulnerable: bool = false

const _k_flame_animation_name: String = "flame"
const _k_explosion_animation_name = "explosion"

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

func _ready() -> void:
	_char_info = Constants.k_characters[selected_character]
	ship_sprite_2d.frame_coords.y = _char_info._ship_row
	_time_per_shot = 1 / float(shots_per_second)
	if player_number == 1:
		collision_layer = Constants.k_player_1_layer
		#collision_layer &= 2
	elif player_number == 2:
		collision_layer = Constants.k_player_2_layer
		#collision_layer &= 1
	_respawn()

func _process(delta: float) -> void:
	if is_destroyed:
		return
		
	_time_since_shot += delta
	if Input.is_action_pressed("action") and _time_since_shot > _time_per_shot:
		_shoot()
		_time_since_shot = 0

func _physics_process(delta: float) -> void:
	if is_destroyed:
		return

	var movementDirection = _getMovementDirectionFromInput()
	_animateMovement(movementDirection)
	var collision = _moveInDirection(movementDirection.normalized() * delta)
	_check_for_collisions(collision)

func _shoot() -> void:
	var projectiles_layer_node = Constants.get_projectiles_layer()
	var n_shots = _shots_per_level[_level]
	for node in shot_nodes:
		var projectile: Projectile = projectile_prefab.instantiate() as Projectile
		projectile.initialize(_char_info._ship_row, player_number, Vector2(0, -1000), 1)
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
		_level = min(_max_level, _level + collider.levels)
		ScoreSystem.add_current_score_for_player_number(player_number, collider.points)
		collider.take()
		return

func _explode() -> void:
	explode_animation_player.play(_k_explosion_animation_name)
	sprites_node_2d.visible = false
	explosion_nodes.visible = true
	is_destroyed = true
	_level = 0

func _respawn() -> void:
	flame_animation_player.play(_k_flame_animation_name)
	explode_animation_player.seek(0)
	sprites_node_2d.visible = true
	explosion_nodes.visible = false
	is_destroyed = false

func _set_invulnerable() -> void:
	is_invulnerable = true
	modulate.a = 0.5
	invulnerable_timer.start()
	
func _set_vulnerable() -> void:
	is_invulnerable = false
	modulate.a = 1

func hit() -> bool:
	if is_destroyed or is_invulnerable:
		return false
	_explode()
	return true

func respawn(delay_seconds: int) -> void:
	respawn_timer.start(delay_seconds)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == _k_explosion_animation_name:
		explosion_nodes.visible = false
		emit_signal(exploded.get_name(), player_number)

func _on_respawn_timer_timeout() -> void:
	_respawn()
	_set_invulnerable()

func _on_invulnerable_timer_timeout() -> void:
	_set_vulnerable()
