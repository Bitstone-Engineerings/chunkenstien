extends State

@onready var teeth:Area2D=$"../../teeth"
func enter():
	super.enter()
	attack()

func attack():
	animation_player.play("attack")
	await animation_player.animation_finished
	attack()

func transition():
	if owner.direction.length()>40:
		get_parent().change_state("follow")
