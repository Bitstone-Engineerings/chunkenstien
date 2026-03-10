extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity : float = -300.0 # You might want to increase this; -150 is a very tiny jump!
@export var bullet_node: PackedScene
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false
@export var knockback_speed: float = 100.0
@onready var timer: Timer = $Timer

signal facing_direction_changed(facing_right: bool)

var hp := 100:
	set(value):
		hp = value
		if value <= 0:
			animated_sprite.play("death")
			await animated_sprite.animation_finished
			get_tree().reload_current_scene()

func damage(knockback_direction: Vector2):
	hp -= 10
	velocity = knockback_speed * knockback_direction
	timer.start()

func _physics_process(delta):
	# Apply gravity if the character is in the air
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		was_in_air = false

	# Handle Jumping
	# Make sure you have a "jump" action defined in your Input Map (e.g., Spacebar, Up arrow)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Handle Attacking
	if Input.is_action_just_pressed("attack") and not animation_locked:
		attack()

	# Get the input direction for horizontal movement only (left and right)
	var direction_x = Input.get_axis("left", "right")
	
	if direction_x != 0:
		velocity.x = direction_x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing_direction(direction_x)
	
func update_animation():
	if not animation_locked:
		if not is_on_floor():
			# If you have a jump/fall animation, you can play it here
			animated_sprite.play("jump") 
			pass
		else:
			if velocity.x != 0:
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")

func update_facing_direction(direction_x: float):
	if direction_x > 0:
		animated_sprite.flip_h = false
		emit_signal("facing_direction_changed", !animated_sprite.flip_h)
	elif direction_x < 0:
		animated_sprite.flip_h = true
		emit_signal("facing_direction_changed", !animated_sprite.flip_h)

func attack():
	animation_locked = true
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_locked = false

#func shoot():
	#var bullet=bullet_node.instantiate()
	#bullet.position=global_position
	#bullet.direction=(get_global_mouse_position()-global_position).normalized()

#func _input(event):
	#if event.is_action("shoot"):
		#shoot()
