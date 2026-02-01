extends Node
@onready var in_game_music: AudioStreamPlayer2D = $"../InGameMusic"

var HpBar1: ProgressBar
var HpBar2: ProgressBar
var TimerBar1: ProgressBar
var TimerBar2: ProgressBar

const HPMAX := 100
const TIMERMAX := 3.0

var Player1HP := HPMAX
var Player2HP := HPMAX

func set_hp_bars():
	HpBar1.max_value = HPMAX
	HpBar2.max_value = HPMAX
	
	HpBar1.value = Player1HP
	HpBar2.value = Player2HP
		
	HpBar1.modulate = health_to_color(Player1HP, HPMAX, Color.ROYAL_BLUE)
	HpBar2.modulate = health_to_color(Player2HP, HPMAX, Color.YELLOW)

func set_timer_1(settime: float):
	TimerBar1.value = settime
	TimerBar1.modulate = health_to_color(settime, TIMERMAX, Color.ROYAL_BLUE)

func set_timer_2(settime: float):
	TimerBar2.value = settime
	TimerBar2.modulate = health_to_color(settime, TIMERMAX, Color.YELLOW)
	
func decreaseHP(delta1 : int, delta2 : int):
	Player1HP -= delta1
	Player2HP -= delta2
	
	set_hp_bars()
	
	if (Player1HP <= 0):
		get_tree().change_scene_to_file("res://Scenes/BlueWin.tscn")
	elif (Player2HP <= 0):
		get_tree().change_scene_to_file("res://Scenes/YellowWin.tscn")

func health_to_color(hp: float, max_hp: float, color: Color) -> Color:
	var target = float(hp) / float(max_hp)
	var grey := Color(0.5,0.5,0.5)
	return grey.lerp(color, target)

func _ready():
	var main_scene = get_tree().current_scene
	HpBar1 = main_scene.get_node("Ui/BlueHP")
	HpBar2 = main_scene.get_node("Ui/YellowHP")
	TimerBar1 = main_scene.get_node("Ui/BlueCooldown")
	TimerBar2 = main_scene.get_node("Ui/YellowCooldown")
	
	TimerBar1.max_value = TIMERMAX
	TimerBar2.max_value = TIMERMAX
	set_timer_1(3)
	set_timer_2(3)
	set_hp_bars() 
	$"../InGameMusic".play()
