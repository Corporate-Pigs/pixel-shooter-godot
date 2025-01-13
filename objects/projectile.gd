extends CharacterBody2D

class_name Projectile

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var shot_row: int = 0

func _ready() -> void:
	sprite_2d.frame_coords.y = shot_row
	velocity = Vector2(0, -3000)

func _physics_process(delta: float) -> void:
	move_and_slide()
