extends CharacterBody2D

@onready var player = get_parent().find_child("body")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar = $ui/MarginContainer/VBoxContainer/ProgressBar
@onready var timer: Timer = $Timer

@export var knockback_speed: float = 100.0
@export var speed: float = 40.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var is_knocked_back: bool = false

signal facing_direction_changed(facing_right: bool)

var health := 100:
	set(value):
		health = value
		if progress_bar:
			progress_bar.value = health
		if value <= 0:
			progress_bar.visible = false
			find_child("rat state machines").change_state("death")

func _ready():
	# Note: You had this set to false. Make sure your state machine turns it back 
	# to true, otherwise _physics_process won't run at all!
	set_physics_process(false) 

func _process(_delta):
	if player:
		direction = player.global_position - global_position
		
	if direction.x < 0:
		animated_sprite.flip_h = true
		emit_signal("facing_direction_changed", !animated_sprite.flip_h)
	else:
		animated_sprite.flip_h = false
		emit_signal("facing_direction_changed", !animated_sprite.flip_h)

func _physics_process(delta):
	# 1. Apply gravity to the Y axis
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Handle X-axis movement (only if not currently recovering from knockback)
	if not is_knocked_back:
		if direction.x != 0:
			# sign() returns -1 (left), 1 (right), or 0.
			velocity.x = sign(direction.x) * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		# Optional: Apply friction so they slide a bit during knockback
		velocity.x = move_toward(velocity.x, 0, 5)

	# 3. Apply movement
	move_and_slide()

func take_damage(knockback_direction: Vector2):
	health -= 20
	is_knocked_back = true
	# Apply the knockback burst
	velocity = knockback_direction * knockback_speed
	timer.start()

func _on_timer_timeout():
	# Instead of manually setting velocity here, we just tell the physics 
	# process it's allowed to take back control of the X axis.
	is_knocked_back = false
