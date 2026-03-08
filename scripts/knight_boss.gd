extends CharacterBody2D

@onready var player=get_parent().find_child("player")
@onready var animated_sprite=$AnimatedSprite2D
@onready var progress_bar=$ui/ProgressBar
@onready var timer:Timer=$Timer
var direction: Vector2
@export var knockback_speed:float= 100.0

var health:=100:
	set(value):
		health=value
		progress_bar.value=value
		if value<=0:
			progress_bar.visible=false
			find_child("Finite State Machines").change_state("death")
func _ready():
	set_physics_process(false)

func _process(_delta):
	direction=player.position-position
	if direction.x<0:
		animated_sprite.flip_h=true
	else:
		animated_sprite.flip_h=false

func _physics_process(delta):
	velocity=direction.normalized()*80
	move_and_collide(velocity*delta)

func take_damage(knockback_direction:Vector2):
	health-=5
	velocity=knockback_speed*knockback_direction
	timer.start()

func _on_timer_timeout():
	velocity=direction.normalized()*80
