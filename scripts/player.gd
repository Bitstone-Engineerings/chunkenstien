extends CharacterBody2D

@export var speed : float = 200.0
@export var jump_velocity : float = -150.0
@export var bullet_node:PackedScene
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer=$AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false

signal facing_direction_changed(facing_right:bool)

var hp:=100:
	set(value):
		hp=value
		if value<=0:
			animated_sprite.play("death")
			await animated_sprite.animation_finished
			get_tree().reload_current_scene()

func damage():
	hp-=20

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		if was_in_air == true:
			land()
			
		was_in_air = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# Normal jump from floor
		jump()
	if Input.is_action_just_pressed("attack"):
		attack()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 && animated_sprite.animation != "jump_end":
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	update_animation()
	update_facing_direction()
	
func update_animation():
	if not animation_locked:
		if not is_on_floor():
			animated_sprite.play("jump_loop")
		else:
			if direction.x != 0:
				animated_sprite.play("walk")
			else:
				animated_sprite.play("idle")

func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		emit_signal("facing_direction_changed",!animated_sprite.flip_h)

func jump():
	velocity.y = jump_velocity
	animated_sprite.play("jump_start")
	animation_locked = true

func land():
	animated_sprite.play("jump_end")
	animation_locked = true

func _on_animated_sprite_2d_animation_finished():
	if(["jump_end", "jump_start"].has(animated_sprite.animation)):
		animation_locked = false

func attack():
	animation_player.play("attack")
	await animated_sprite.animation_finished
	animation_locked=false

func shoot():
	var bullet=bullet_node.instantiate()
	bullet.position=global_position
	bullet.direction=(get_global_mouse_position()-global_position).normalized()

func _input(event):
	if event.is_action("shoot"):
		shoot()
