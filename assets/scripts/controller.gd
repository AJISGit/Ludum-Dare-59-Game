extends CharacterBody2D


@onready var move_timer: Timer = $MoveTimer


func _on_move_timer_timeout():
	move_timer.wait_time = randf_range(0.0, 2.0)

	var rand_num = randi_range(0, 2)

	if rand_num == 0:
		velocity.x = -velocity.x
	elif rand_num == 1:
		velocity.y = - velocity.y
	else:
		velocity.x = -velocity.x
		velocity.y = -velocity.y
	
	move_timer.start()


func _ready() -> void:
	move_timer.timeout.connect(_on_move_timer_timeout)
	move_timer.start()
	velocity = Vector2(10.0, -10.0)

func _physics_process(_delta: float) -> void:

	move_and_slide()
