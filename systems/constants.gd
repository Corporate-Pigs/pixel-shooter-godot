extends Node

const k_up = "up"
const k_down = "down"
const k_left = "left"
const k_right = "right"
const k_insert_coin = "insert-coin"
const k_action = "action"
const k_back = "back"
const k_start = "start"

const k_enemy_layer = 16
const k_player_1_layer = 1
const k_player_2_layer = 2
const k_enemy_shot_layer = 32
const k_player_1_shot_layer = 4
const k_player_2_shot_layer = 8

class CharacterInfo:
	var _name: String = ""
	var _sprite_row: int = 0
	var _ship_row: int = 0
	var _shot_frame: int = 0
	var _explosion_row: int = 0

	func _init(
		name: String, 
		sprite_row: int, 
		ship_row: int, 
		shot_frame: int,
		explosion_row: int):
		self._name = name
		self._sprite_row = sprite_row
		self._ship_row = ship_row
		self._shot_frame = shot_frame
		self._explosion_row = explosion_row

var k_characters = [
	CharacterInfo.new("John", 0, 0, 2, 0),
	CharacterInfo.new("Anna", 1, 1, 12, 0),
	CharacterInfo.new("Kyle", 2, 2, 7, 0),
]

func get_projectiles_layer() -> Node2D:
	var root_scene = get_tree().root.get_child(3)
	return root_scene.get_node("ProjectilesLayer")
