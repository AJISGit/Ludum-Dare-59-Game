extends CharacterBody2D


@onready var move_timer: Timer = $MoveTimer


func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(0.0, 2.0)

	var rand_num = randi_range(0, 5)

	if rand_num == 0:
		velocity.x = -velocity.x
	elif rand_num == 1:
		velocity.y = -velocity.y
	elif rand_num == 2:
		velocity.x += randi_range(-50, 50)
	elif rand_num == 3:
		velocity.y += randi_range(-50, 50)
	elif rand_num == 4:
		velocity.x += randi_range(-50, 50)
		velocity.y += randi_range(-50, 50)
	else:
		velocity.x = -velocity.x
		velocity.y = -velocity.y


		
	
	move_timer.start()


func _ready() -> void:
	move_timer.timeout.connect(_on_move_timer_timeout)
	move_timer.start()
	velocity = Vector2(10.0, -10.0)

func _physics_process(_delta: float) -> void:

	velocity.x = clampf(velocity.x, -10.0, 10.0)
	velocity.y = clampf(velocity.y, -10.0, 10.0)

	move_and_slide()
