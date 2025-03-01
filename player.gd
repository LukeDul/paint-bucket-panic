extends CharacterBody2D
const SPEED = 50.0
const JUMP_VELOCITY = -200.0
var jump_boost_multiplier = 1.0
@export var max_y: int 
@onready var score = $Camera2D/Label
@onready var animated_sprite = $AnimatedSprite2D
var flag = false

func _ready():
	max_y = position.y

func _process(delta: float):
	if position.y < max_y: max_y = position.y
	score.text = "Score: %s" % (abs(max_y) - 33)
	
	# Handle animations based on movement direction
	if velocity.x > 0 and flag == false:
		animated_sprite.play("run_white_right")
		animated_sprite.flip_h = false
	elif velocity.x > 0 and flag == true:
		animated_sprite.play("run_rainbow_right")
		animated_sprite.flip_h = false
	elif velocity.x < 0 and flag == false:
		animated_sprite.play("run_white_right")  # ********USING RIGHT RUNNING FOR BOTH - 
		animated_sprite.flip_h = true  # Just flip it horizontally
	elif velocity.x < 0 and flag == true:
		animated_sprite.play("run_rainbow_right")  # Use the same animation
		animated_sprite.flip_h = true  # Just flip it horizontally		
	elif velocity.x == 0:  # Changed from "else" to specifically check for zero velocity
		if flag == false:
			animated_sprite.play("idle_white")
		else:
			animated_sprite.play("idle_color")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: velocity += Vector2(0, 400) * delta
		else: velocity += Vector2(0, 980) * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_boost_multiplier
		$AudioStreamPlayer2D.play()
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

# Jump boost method remains unchanged
func apply_jump_boost(amount, duration):
	$SplatSoundEffect.play()
	print("Jump boost applied: ", amount, " for ", duration, " seconds")
	jump_boost_multiplier = amount
	modulate = Color(0.5, 1.0, 0.5)
	var timer = Timer.new()
	add_child(timer)
	flag = true
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(func():
		jump_boost_multiplier = 1.0
		modulate = Color(1, 1, 1)
		print("Jump boost expired")
		timer.queue_free()
		flag = false
	)
	timer.start()
