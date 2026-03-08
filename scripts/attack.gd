extends State

@onready var sword:Area2D= $"../../sword"
func enter():
	super.enter()
	combo()

func attack(move="1"):
	animation_player.play("attack"+move)
	await animation_player.animation_finished


func combo():
	var move_set=["1","1","2"]
	for i in move_set:
		await attack(i)
		sword._on_body_entered()
	combo()

func transition():
	if owner.direction.length()>40:
		get_parent().change_state("follow")


func _on_sword_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
