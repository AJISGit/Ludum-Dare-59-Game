extends CharacterBody2D


@export_group("Movement")
@export var speed: float = 300.0
@onready var normal_speed = speed

@export_group("Health")
@export var health: int = 3 
@export var max_health: int = 3 

@export_group("Controller")
@export var max_distance: float = 100


enum player_state {
	walking,
	idle,
	frozen,
}

enum player_direction {
	front,
	back,
	left,
	right,
}

@export var state: player_state = player_state.idle
var direction: player_direction = player_direction.back


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var health_bar: HealthBar = %HealthBar	
@onready var shoot_timer: Timer = $ShootTimer


var play_idle_animation_while_frozen: bool = true
var shooting: bool = false
var can_shoot: bool = true

var BULLET_RESOURCE: PackedScene = preload("res://assets/scenes/bullet.tscn")
var LASER_SHOOT_NOISE = preload("res://assets/sounds/shoot.wav")
var LASER_ALT_SHOOT_NOISE = preload("res://assets/sounds/shoot2.wav")

var alt_shoot_noise: bool = false


func _ready() -> void:
	health_bar.update_icons(health, max_health)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _on_shoot_timer_timeout():
	can_shoot = true

func _on_bullet_hit(body: Node2D):
	if body == %Enemy:
		body.health -= 1

func _physics_process(delta: float) -> void:

	# Reset Values
	velocity = Vector2(0.0, 0.0)


	# Make sure health is in the correct range
	if health > max_health: health = max_health
	if health < 0: health = 0

	if health <= 0:
		get_tree().paused = true

	health_bar.update_icons(health, max_health)
	
	# Change player based on distance to controller

	var distance: float = position.distance_to(%Controller.position)
	
	if distance >= max_distance / 1.2:
		speed = normal_speed / 3 
	elif distance >= max_distance / 2:
		speed = normal_speed / 1.5
	else:
		speed = normal_speed


	if distance > max_distance:
		%Static.get_material().set_shader_parameter("noise_intensity", 1.0)
		state = player_state.frozen
	else:
		state = player_state.idle

	if state != player_state.frozen:
		state = player_state.idle
		

	
	#### Movement ####
	if Input.is_action_pressed("WalkLeft") and state != player_state.frozen:
		velocity.x = -(speed * delta)
		state = player_state.walking
		direction = player_direction.left
	if Input.is_action_pressed("WalkRight") and state != player_state.frozen:
		velocity.x = speed * delta
		state = player_state.walking
		direction = player_direction.right
	if Input.is_action_pressed("WalkUp") and state != player_state.frozen:
		velocity.y = -(speed * delta)
		state = player_state.walking
		direction = player_direction.front
	if Input.is_action_pressed("WalkDown") and state != player_state.frozen:
		velocity.y = speed * delta
		state = player_state.walking
		direction = player_direction.back
	
	
	#### Animation ####
	if state == player_state.walking:
			
			
			if direction == player_direction.front:
				sprite.play("WalkBack")
			elif direction == player_direction.back:
				sprite.play("WalkFront")
			elif direction == player_direction.right:

				sprite.flip_h = true
				sprite.play("WalkSide")
			elif direction == player_direction.left:

				sprite.flip_h = false 
				sprite.play("WalkSide")

			
	elif state == player_state.idle:
		
		play_idle_animation()

	elif state == player_state.frozen:
		if play_idle_animation_while_frozen:
			sprite.play("Dead")	
			sprite.flip_h = false

	if (shooting) and (state != player_state.frozen):
		shoot()


	move_and_slide()

	if (state != player_state.frozen):
		%Static.get_material().set_shader_parameter("noise_intensity", distance / 125.0)





func _input(event: InputEvent) -> void:
	# Let player shoot bullets
	if event.is_action_pressed("Shoot"):
		shooting = true
	elif event.is_action_released("Shoot"):
		shooting = false



func shoot():

	if !can_shoot: return

	var bullet: Bullet = BULLET_RESOURCE.instantiate()
	bullet.position = position
	bullet.speed = 100
	bullet.look_at(get_global_mouse_position())
	bullet.hit.connect(_on_bullet_hit)
	bullet.set_collision_layer_value(3, true)
	bullet.set_collision_layer_value(1, false)
	bullet.set_collision_mask_value(3, true)
	bullet.set_collision_mask_value(1, false)

	$"../".add_child(bullet)

	if !alt_shoot_noise:
		%AudioPlayer.set_stream(LASER_SHOOT_NOISE)
		%AudioPlayer.stop()
		%AudioPlayer.play()
	else:
		%AudioPlayer2.set_stream(LASER_ALT_SHOOT_NOISE)
		%AudioPlayer2.stop()
		%AudioPlayer2.play()
	
	alt_shoot_noise = !alt_shoot_noise



	can_shoot = false
	shoot_timer.start()



func play_idle_animation() -> void:
	if direction == player_direction.front:
		sprite.flip_h = false
		sprite.play("IdleBack")
	elif direction == player_direction.back:
		sprite.flip_h = false
		sprite.play("IdleFront")
	elif direction == player_direction.right:
		sprite.flip_h = true 
		sprite.play("IdleSide")
	elif direction == player_direction.left:
		sprite.flip_h = false 
		sprite.play("IdleSide")

	
