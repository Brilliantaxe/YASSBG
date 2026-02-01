extends Node

@export var HpBar1: ProgressBar
@export var HpBar2: ProgressBar

const HPMAX := 100

var Player1HP := HPMAX
var Player2HP := HPMAX

func set_bars():
	HpBar1.max_value = HPMAX
	HpBar2.max_value = HPMAX
	
	HpBar1.value = Player1HP
	HpBar2.value = Player2HP
		
	HpBar1.modulate = health_to_color(Player1HP, HPMAX, Color.ROYAL_BLUE)
	HpBar2.modulate = health_to_color(Player1HP, HPMAX, Color.YELLOW)
	
func decreaseHP(delta1 : int, delta2 : int):
	Player1HP -= delta1
	Player2HP -= delta2
	
	set_bars()
	
	if (Player1HP <= 0):
		get_tree().change_scene_to_file("res://Scenes/YellowWin.tscn")
	elif (Player2HP <= 0):
		get_tree().change_scene_to_file("res://Scenes/BlueWin.tscn")

func health_to_color(hp: int, max_hp: int, color: Color) -> Color:
	var target = float(hp) / float(max_hp)
	var grey := Color(0.5,0.5,0.5)
	return grey.lerp(color, target)
	

func _ready():
	set_bars()
