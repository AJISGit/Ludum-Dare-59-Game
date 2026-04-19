extends Node


func _on_start_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()	

func _ready() -> void:
	$StartButton.pressed.connect(_on_start_button_pressed)
