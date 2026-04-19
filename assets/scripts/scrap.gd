class_name Scrap
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body == $"../Player":
		body.health += 1
		queue_free()


func _ready() -> void:
	body_entered.connect(_on_body_entered)

