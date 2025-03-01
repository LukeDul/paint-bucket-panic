extends CharacterBody2D
const SPEED = 50.0
const JUMP_VELOCITY = -200.0
var jump_boost_multiplier = 1.0  # Add this line
@export var max_y: int 
@onready var score = $Camera2D/Label

func _ready():
	max_y = position.y

func _process(delta: float):
	if position.y < max_y: max_y = position.y
	score.text = "Score: %s" % (abs(max_y) - 33)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0, 980) * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_boost_multiplier  # Modify this line
		$AudioStreamPlayer2D.play()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

# Add this method
func apply_jump_boost(amount, duration):
	print("Jump boost applied: ", amount, " for ", duration, " seconds")
	jump_boost_multiplier = amount
	modulate = Color(0.5, 1.0, 0.5)  # Green glow effect
	
	# Create a timer to reset the boost after duration
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(func():
		jump_boost_multiplier = 1.0
		modulate = Color(1, 1, 1)
		print("Jump boost expired")
		timer.queue_free()
	)
	timer.start()
