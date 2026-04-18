class_name Bullet
extends Area2D

signal hit
var speed: float = 200.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += Vector2(1, 0).rotated(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	hit.emit(body)
	queue_free()
