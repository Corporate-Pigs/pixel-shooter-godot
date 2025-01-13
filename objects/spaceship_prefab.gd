extends CharacterBody2D

class_name Spaceship

@onready var ship_sprite_2d: Sprite2D = $ShipSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shot_node_2d_0: Node2D = $ShotNode2D0
@onready var shot_node_2d_1: Node2D = $ShotNode2D1
@onready var shot_nodes = [shot_node_2d_0, shot_node_2d_1]

@export var selected_character: int = 0
@export var speed: int = 50000
@export var projectile_prefab: PackedScene

var char_info = Constants.k_characters[selected_character]

func _getMovementDirectionFromInput() -> Vector2:
	var verticalInput = Input.get_axis("up", "down")
	var horizontalInput = Input.get_axis("left", "right")
	return Vector2(horizontalInput, verticalInput)

func _moveInDirection(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		velocity = direction
		return
	velocity = direction * speed
	move_and_slide()

func _animateMovement(direction: Vector2) -> void:
	ship_sprite_2d.frame_coords.x = 1 + int(direction.x)

func _process(_delta: float) -> void:
	ship_sprite_2d.frame_coords.y = char_info._ship_row
	if Input.is_action_just_pressed("action"):
		for node in shot_nodes:
			var projectile = projectile_prefab.instantiate() as Projectile
			projectile.global_position = node.global_position
			get_tree().root.add_child(projectile)

func _physics_process(delta: float) -> void:
	var movementDirection = _getMovementDirectionFromInput()
	_moveInDirection(movementDirection.normalized() * delta)
	_animateMovement(movementDirection)
