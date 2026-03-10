extends Node2D
@onready var knight_boss= $"knight boss"
@onready var player = $body/fists


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player.body_entered.connect(knight_boss._on_body_entered)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
