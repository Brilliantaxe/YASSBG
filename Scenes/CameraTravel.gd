extends Camera2D

@export var panels: Array[Marker2D]
@export var audios: Array[AudioStream]
@export var move_time := 1.2

@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_panel := -1

func go_to_panel(index: int):
	current_panel = index
	var target = panels[index]
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target.global_position, move_time)\
	  .set_trans(Tween.TRANS_SINE)\
	  .set_ease(Tween.EASE_IN_OUT)
	
	tween.parallel().tween_property(
		self,
		"zoom",
		Vector2.ONE * target.get("scale"),
		move_time
	)
	
	sfx.stream = audios[index]
	sfx.play()


func _on_button_pressed() -> void:
	if current_panel >= panels.size() - 1:
		return
	
	go_to_panel(current_panel + 1)
	pass # Replace with function body.
