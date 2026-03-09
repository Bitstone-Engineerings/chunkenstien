extends Area2D

@onready var character:CharacterBody2D=$".."
@onready var fcs:CollisionShape2D=$CollisionShape2D

func _ready():
	monitoring=false
	character.connect("facing_direction_changed",_on_rat_boss_facing_diection_changed)

func _on_body_entered(body:CharacterBody2D ):
	var direction_to_enemy=(body.global_position-get_parent().global_position)
	var dsign=sign(direction_to_enemy.x)
	if(dsign>0):
		body.damage(Vector2.RIGHT)
	elif(dsign<0):
		body.damage(Vector2.LEFT)
	else:
		body.damage(Vector2.ZERO)

func _on_rat_boss_facing_diection_changed(facing_right:bool):
	if(facing_right):
		fcs.position=fcs.facing_right_position
	else:
		fcs.position=fcs.facing_left_position
