extends Area2D

func _ready():
	monitoring=false

func _on_body_entered(body: CharacterBody2D):
	body.take_damage()
	print_debug(body.name+ "took damage.")
