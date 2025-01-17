extends CharacterBody2D

class_name Projectile

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var shot_row: int = 0
@export var player_number: int = 0

func initialize(shot_row: int, player_number: int) -> void:
	self.shot_row = shot_row
	self.player_number = player_number
	if player_number > 0:
		collision_layer &= ~32  

func _ready() -> void:
	sprite_2d.frame_coords.y = shot_row
	velocity = Vector2(0, -1000)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func hit() -> void:
	queue_free()
