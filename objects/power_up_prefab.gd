extends CharacterBody2D

class_name PowerUp

@export var points = 100
@export var levels = 1

func _physics_process(_delta: float) -> void:
	move_and_collide(Vector2(0, 1))

func take() -> void:
	queue_free()
