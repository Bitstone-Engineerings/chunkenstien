extends State
@onready var collision = $"../../player detection/CollisionShape2D"
@onready var progress_bar=owner.find_child("ProgressBar")


var player_entered:bool=false:
	set(value):
		player_entered=value
		collision.set_deferred("disabled",value)
		progress_bar.set_deferred("visible",value)

func _on_player_detection_body_entered(_body):
	player_entered=true

func transition():
	if player_entered:
		find_parent("rat state machines").change_state("follow")
