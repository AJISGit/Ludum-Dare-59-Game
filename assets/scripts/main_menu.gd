extends Node


var LEVEL_RESOURCE: PackedScene = preload("res://assets/scenes/level.tscn")


func _on_start_button_pressed():

	var level = LEVEL_RESOURCE.instantiate()
	$"..".add_child(level)

	queue_free()


func _ready() -> void:
	$StartButton.pressed.connect(_on_start_button_pressed)
