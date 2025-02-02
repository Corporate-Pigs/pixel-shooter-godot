extends CanvasLayer

class_name GameOverHud

signal on_game_over()

@onready var center_container: CenterContainer = $CenterContainer
@onready var count_down_label: Label = $CenterContainer/VBoxContainer/CountDownLabel
@onready var continue_label: Label = $CenterContainer/VBoxContainer/ContinueLabel
@onready var count_down_timer: Timer = $CountDownTimer
@onready var game_over_delay_timer: Timer = $GameOverDelayTimer
@onready var game_over_stream_player: AudioStreamPlayer = $GameOverStreamPlayer

var _count_number = 9
var is_on_gameover_delay = false

func _ready() -> void:
	stop_count_down()
	is_on_gameover_delay = false

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
		count_down_timer.stop()
		count_down_label.visible = false
		continue_label.visible = false
		game_over_delay_timer.start()
		is_on_gameover_delay = true
		game_over_stream_player.play()

func _on_game_over_delay_timer_timeout() -> void:
	game_over_delay_timer.stop()
	emit_signal(on_game_over.get_name())
