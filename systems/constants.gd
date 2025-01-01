extends Node

const k_up = "up"
const k_down = "down"
const k_left = "left"
const k_right = "right"
const k_insert_coin = "insert-coin"
const k_action = "action"
const k_back = "back"

class CharacterInfo:
	var _name: String = ""
	var _sprite_row: int = 0
	var _ship_row: int = 0
	var _shot_frame: int = 0

	func _init(name: String, sprite_row: int, ship_row: int, shot_frame: int):
		self._name = name
		self._sprite_row = sprite_row
		self._ship_row = ship_row
		self._shot_frame = shot_frame

var k_characters = [
	CharacterInfo.new("John", 0, 0, 2),
	CharacterInfo.new("Anna", 1, 1, 12),
	CharacterInfo.new("Kyle", 2, 2, 7),
]
