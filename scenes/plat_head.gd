extends CharacterBody2D
@onready var head: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 40.0
const JUMP_VELOCITY = -140.0


var check_timer = 0.0
var check_interval = 2.0

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	check_timer += delta
	
	if check_timer >= check_interval:
		check_timer = 0.0
		 
		var random_num = randi() % 100
		if(random_num>30):
			velocity.y+=JUMP_VELOCITY
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if(direction<0):
		head.flip_h=true;
	else:
		head.flip_h=false;
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
