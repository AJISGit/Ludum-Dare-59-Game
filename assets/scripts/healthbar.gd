class_name HealthBar
extends Node2D

# I assume the exact same layout as scenes/health_bar.tscn

func update_icons(health: int, max_health: int) -> void:
	for i in range(1, max_health + 1):
		
		var sprite: Sprite2D = get_node("Icon" + str(i))
		if health >= i:
			sprite.self_modulate = Color8(255, 0, 0, 255)
		else:
			sprite.self_modulate = Color8(132, 126, 135, 255)


