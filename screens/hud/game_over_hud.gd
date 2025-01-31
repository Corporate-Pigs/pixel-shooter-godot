extends CanvasLayer

class_name GameOverHud

signal on_game_over()

@onready var center_container: CenterContainer = $CenterContainer
@onready var count_down_label: Label = $CenterContainer/VBoxContainer/CountDownLabel
@onready var count_down_timer: Timer = $CountDownTimer

var _count_number = 9

func _ready() -> void:
	stop_count_down()

func _update_count_down() -> void:
	_count_number -= 1
	count_down_label.text = str(_count_number)

func start_count_down() -> void:
	count_down_timer.start()
	center_container.visible = true

func stop_count_down() -> void:
	count_down_timer.stop()
	center_container.visible = false

func _on_count_down_timer_timeout() -> void:
	_update_count_down()
	if _count_number == -1:
		stop_count_down()
		emit_signal(on_game_over.get_name())
