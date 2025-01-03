extends Node2D

class_name ParalaxBackground

@export var animation_speed: float = 0.25
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_paralax_speed_factor(speed: float) -> void:
	animation_speed *= speed
	animation_player.speed_scale = animation_speed

func _ready() -> void:
	animation_player.play("paralax")
	animation_player.speed_scale = animation_speed
