extends CharacterBody2D


@export_group("Movement")
@export var speed: float = 300.0

@export_group("Health")
@export var health: int = 3 
@export var max_health: int = 3 


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


var play_idle_animation_while_frozen: bool = true


func _ready() -> void:
	health_bar.update_icons(health, max_health)

func _physics_process(delta: float) -> void:

	#### Reset Values ####
	velocity = Vector2(0.0, 0.0)

	if health > max_health: health = max_health
	if health < 0: health = 0

	if health <= 0: get_tree().paused = true

	health_bar.update_icons(health, max_health)
	
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
			play_idle_animation()


	move_and_slide()



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
