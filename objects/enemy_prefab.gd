extends Area2D

class_name Enemy

@onready var ship_sprite: Sprite2D = $ShipSprite
@onready var explosion_sprite: Sprite2D = $Explosion/ExplosionSprite
@onready var animation_player: AnimationPlayer = $Explosion/AnimationPlayer
@onready var shot_node_2d: Node2D = $ShotNode2D

@export var hitpoints: int = 3
@export var speed: int = 100
@export var points: int = 1000
@export var shots_per_second: int = 1
@export var projectile_prefab: PackedScene
@export var power_up_spawn_rate: float = 0.5

var _time_since_shot: float = 0
var _time_per_shot: float = 1

const k_explosion_animation_name = "explosion"
var _projectile_speed: int = 300
var _shooting_direction: Vector2 = Vector2(0, 1)
var _move_speed: Vector2 = Vector2(0, 0)

func _check_for_collisions(collision: KinematicCollision2D) -> void:
	if collision == null:
		return
		
	var collider = collision.get_collider()
	if collider is not Projectile:
		return
		
	var player_number = collider._player_number
	collider.hit()
	if player_number == 0:
		return
	_explode()

func _shoot() -> void:
	var projectiles_layer_node = Constants.get_projectiles_layer()
	var projectile: Projectile = projectile_prefab.instantiate() as Projectile
	projectile.initialize(12, 0, _projectile_speed * _shooting_direction, 1)
	var shoot_position = shot_node_2d.global_position
	projectile.global_position = shoot_position
	projectiles_layer_node.add_child(projectile)
	_shooting_direction = Vector2(randf(), randf()).normalized()

func _explode() -> void:
	ship_sprite.visible = false
	explosion_sprite.visible = true
	animation_player.play(k_explosion_animation_name)

func _ready() -> void:
	ship_sprite.visible = true
	explosion_sprite.visible = false
	_move_speed = Vector2(randi() % 60 - 30, 100)
	_time_per_shot = 1 / float(shots_per_second)

func _process(delta: float) -> void:
	_time_since_shot += delta
	if hitpoints > 0 and _time_since_shot > _time_per_shot and not is_offscreen():
		_shoot()
		_time_since_shot = 0

func _physics_process(delta: float) -> void:
	position += _move_speed * delta

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == k_explosion_animation_name:
		queue_free()

func hit(area: Area2D) -> void:
	var projectile: Projectile = area
	hitpoints -= projectile._damage
	if hitpoints != 0:
		area.hit()
		return
	ScoreSystem.add_current_score_for_player_number(projectile._player_number, points)
	_explode()

func despawn() -> void:
	queue_free()

func is_offscreen() -> bool:
	var screen_size = get_viewport().get_visible_rect().size
	var node_position = global_position
	return node_position.x < 0 or node_position.x > screen_size.x or node_position.y < 0 or node_position.y > screen_size.y
