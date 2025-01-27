extends Node2D

@onready var wave_spawner_timer: Timer = $WaveSpawnerTimer

@export var enemy_layer_node: Node2D
@export var enemy_prefab: PackedScene
@export var spawns_per_wave: int = 10

signal on_enemy_destroyed(position: Vector2, player_number: int)

func _spawn_wave() -> void:
	for _i in spawns_per_wave:
		var position = _get_spawn_position()
		_spawn_enemy(position)

func _get_spawn_position() -> Vector2:
	var x = randi() % 850
	var y = -50 + randi() % 10
	return Vector2(x, y)

func _spawn_enemy(position: Vector2) -> void:
	var enemy = enemy_prefab.instantiate()
	enemy.connect("exploded", _enemy_exploded)
	enemy.global_position = position
	enemy_layer_node.add_child(enemy)

func _on_wave_spawner_timer_timeout() -> void:
	_spawn_wave()
	
func _enemy_exploded(position: Vector2, player_number: int) -> void:
	emit_signal(on_enemy_destroyed.get_name(), position, player_number)
