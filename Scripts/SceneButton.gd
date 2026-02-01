extends Button

@export var TargetScene: PackedScene

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(TargetScene)
	pass # Replace with function body.
