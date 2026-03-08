extends CharacterBody2D

@onready var player = get_parent().find_child("player")
@onready var animated_sprite=$AnimatedSprite2D

var direction: Vector2
@onready var progress_bar = $ui/MarginContainer/VBoxContainer/ProgressBar
@onready var timer:Timer=$Timer
@export var knockback_speed:float= 100.0

signal facing_direction_changed(facing_right:bool)

var health:=100:
	set(value):
		health=value
		if progress_bar:
			progress_bar.value = health
		if value<=0:
			progress_bar.visible=false
			find_child("Finite State Machines").change_state("death")
func _ready():
	set_physics_process(false)

func _process(_delta):
	if player:
		direction=player.position-position
	if direction.x<0:
		animated_sprite.flip_h=true
		emit_signal("facing_direction_changed",!animated_sprite.flip_h)
	else:
		animated_sprite.flip_h=false
		emit_signal("facing_direction_changed",!animated_sprite.flip_h)

func _physics_process(delta):
	velocity=direction.normalized()*80
	move_and_collide(velocity*delta)

func take_damage(knockback_direction:Vector2):
	health-=5
	velocity=knockback_speed*knockback_direction
	timer.start()

func _on_timer_timeout():
	velocity=direction.normalized()*80
