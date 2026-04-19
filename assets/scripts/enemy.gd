extends CharacterBody2D

const BULLET_RESOURCE: PackedScene = preload("res://assets/scenes/enemy_bullet_1.tscn")
@onready var move_timer: Timer = $MoveTimer

@export var health = 3

enum shoot_phase {cshoot, aim, chaos}

var phase: shoot_phase = randi_range(0, 2) as shoot_phase 
var can_shoot: bool = true



func switch_phase(current_phase: shoot_phase):
	phase = randi_range(0, 2) as shoot_phase
	if (phase == current_phase):
		switch_phase(current_phase)
	else:
		can_shoot = false
		$SwitchTimer.start()



# Per phase data
# Cshoot

var bullet_dir: float = 0

func cshoot_phase():

	if bullet_dir >= 1080:
		bullet_dir = 0
		switch_phase(phase)
		return

	$ShootTimer.wait_time = 0.05
	var bullet: Bullet = BULLET_RESOURCE.instantiate()
	bullet.hit.connect(_on_bullet_hit)
	bullet.position = $LeftGun.global_position
	bullet.speed = 40
	bullet.rotation_degrees = bullet_dir
	$"../".add_child(bullet)

	bullet_dir += 10


# Aim

var aim_shot: int = 0

func aim_phase():

	if aim_shot > 60:
		aim_shot = 0
		switch_phase(phase)
		return



	$ShootTimer.wait_time = 0.35
	var bullet: Bullet = BULLET_RESOURCE.instantiate()
	bullet.hit.connect(_on_bullet_hit)
	bullet.position = $RightGun.global_position
	bullet.speed = 50
	bullet.look_at(%Player.position) 
	$"../".add_child(bullet)



	var bullet2: Bullet = BULLET_RESOURCE.instantiate()
	bullet2.hit.connect(_on_bullet_hit)
	bullet2.position = $LeftGun.global_position
	bullet2.speed = 50
	bullet2.look_at(%Player.position) 
	bullet2.rotation_degrees += 30
	$"../".add_child(bullet2)



	var bullet3: Bullet = BULLET_RESOURCE.instantiate()
	bullet3.hit.connect(_on_bullet_hit)
	bullet3.position = $RightGun.global_position
	bullet3.speed = 50
	bullet3.look_at(%Player.position) 
	bullet3.rotation_degrees -= 30
	$"../".add_child(bullet3)


	aim_shot += 1


# Chaos

var chaos_dir1: float = 0
var chaos_dir2: float = 1800

func chaos_phase():

	if chaos_dir1 > 1800:
		chaos_dir1 = 0
		chaos_dir2 = 1800
		switch_phase(phase)
		return

	$ShootTimer.wait_time = 0.05
	var bullet: Bullet = BULLET_RESOURCE.instantiate()
	bullet.hit.connect(_on_bullet_hit)
	bullet.position = $LeftGun.global_position
	bullet.speed = 30 
	bullet.rotation_degrees = chaos_dir1
	$"../".add_child(bullet)

	var bullet2: Bullet = BULLET_RESOURCE.instantiate()
	bullet2.hit.connect(_on_bullet_hit)
	bullet2.position = $RightGun.global_position
	bullet2.speed = 15 
	bullet2.rotation_degrees = chaos_dir2
	$"../".add_child(bullet2)

	chaos_dir1 += 10
	chaos_dir2 -= 15



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


func _on_switch_timer_timeout():
	can_shoot = true



func _on_shoot_timer_timeout():
	
	if !can_shoot: return

	if phase == shoot_phase.cshoot:
		cshoot_phase()
	elif phase == shoot_phase.aim:
		aim_phase()
	elif phase == shoot_phase.chaos:
		chaos_phase()


func _ready() -> void:
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)
	$SwitchTimer.timeout.connect(_on_switch_timer_timeout)

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
		
		get_tree().paused = true
		$"../../WinMenu/Title".visible = true
		$"../../WinMenu/StartButton".visible = true
		queue_free()

func _physics_process(_delta: float) -> void:

	move_and_slide()
