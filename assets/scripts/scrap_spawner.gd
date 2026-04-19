class_name ScrapSpawner
extends Node


@onready var spawn_timer: Timer = $SpawnTimer

const SCRAP_RESOURCE: PackedScene = preload("res://assets/scenes/scrap.tscn")


func _on_spawn_timer_timeout():

	if randi_range(1, 4) != 1:

		return

	var window_size: Vector2 = get_window().size
	var pos: Vector2 = Vector2(randf_range(-window_size.x, window_size.x), randf_range(-window_size.y, window_size.y))

	var scrap: Scrap = SCRAP_RESOURCE.instantiate()
	scrap.position = pos
	$"../".add_child(scrap)
	print(pos)


func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
