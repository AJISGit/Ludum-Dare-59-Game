extends CharacterBody2D

const BULLET_RESOURCE: PackedScene = preload("res://assets/scenes/bullet.tscn")
@onready var move_timer: Timer = $MoveTimer

@export var health = 3


func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(0.0, 2.0)

	var rand_num = randi_range(0, 6)

	
	if rand_num == 0:
		velocity.x = -velocity.x
	elif rand_num == 1:
		velocity.y = -velocity.y
	elif rand_num == 2:
		velocity.x += randi_range(-15, 15)
	elif rand_num == 3:
		velocity.y += randi_range(-15, 15)
	elif rand_num == 4:
		velocity.x += randi_range(-15, 15)
		velocity.y += randi_range(-15, 15)
	elif rand_num == 5:
		velocity = Vector2(0, 0)
	else:
		velocity.x = -velocity.x
		velocity.y = -velocity.y
	

	move_timer.start()


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

	move_timer.timeout.connect(_on_move_timer_timeout)
	move_timer.start()
	velocity = Vector2(10.0, -10.0)


func _process(_delta: float) -> void:

	if velocity.x < 0:
		velocity.x = -10
	elif velocity.x > 0:
		velocity.x = 10
	else:
		velocity.x = 0


	if velocity.y < 0:
		velocity.y = -10
	elif velocity.y > 0:
		velocity.y = 10
	else:
		velocity.y = 0


	$Label.text = "Health: " + str(health)
	if health <= 0:
		queue_free()

func _physics_process(_delta: float) -> void:

	move_and_slide()
