extends CharacterBody2D

const BULLET_RESOURCE: PackedScene = preload("res://assets/scenes/bullet.tscn")
@export var health = 3

func _on_bullet_hit(body: Node2D):
	if (body == %Player):
		%Player.health -= 1

func _on_shoot_timer_timeout():

	var bullet: Bullet = BULLET_RESOURCE.instantiate()
	bullet.hit.connect(_on_bullet_hit)
	bullet.position = position
	bullet.speed = 100
	bullet.look_at(%Player.position)
	$"../".add_child(bullet)


func _ready() -> void:
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)


func _process(_delta: float) -> void:
	$Label.text = "Health: " + str(health)
	if health <= 0:
		queue_free()
