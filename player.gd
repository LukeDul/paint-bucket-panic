extends CharacterBody2D
const SPEED = 50.0
const JUMP_VELOCITY = -200.0
var jump_boost_multiplier = 1.0
@export var max_y: int
@onready var score = $Camera2D/Label
@onready var animated_sprite = $AnimatedSprite2D
var jumpingflag = false
var previous_score_milestone = 0  # Track the last milestone we passed


# Remove var flag = false (no longer needed)

func _ready():
	max_y = position.y

func _process(delta: float):
	if position.y < max_y: max_y = position.y
	
	# Calculate current score
	var current_score = abs(max_y) - 33
	score.text = "Score: %s" % current_score
	
	# Check for milestone (every 1000 points)
	var current_milestone = int(current_score / 500)
	if current_milestone > previous_score_milestone:
		# Milestone reached!
		milestone_reached()
		previous_score_milestone = current_milestone

func milestone_reached():
	# Play sound effect
	$AudioStreamPlayer2DMilestone.play()  # Create this node if it doesn't exist
	
	# Change text color to yellow
	score.add_theme_color_override("font_color", Color(1, 1, 0))  # Yellow
	
	# Create a timer to reset the text color
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0  # Show yellow for 1 second
	timer.one_shot = true
	timer.timeout.connect(func():
		score.add_theme_color_override("font_color", Color(1, 1, 1))  # Back to white
		timer.queue_free()
	)
	timer.start()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if velocity.y > 0: velocity += Vector2(0, 400) * delta
		else: velocity += Vector2(0, 980) * delta
		if velocity.x < 0:
			animated_sprite.flip_h = true
		elif velocity.x > 0:
			animated_sprite.flip_h = false
	if is_on_floor():
		if velocity.x > 0 and jump_boost_multiplier == 1.0:
			animated_sprite.play("run_white_right")
			animated_sprite.flip_h = false
		elif velocity.x > 0:
			animated_sprite.play("run_rainbow_right")
			animated_sprite.flip_h = false
		elif velocity.x < 0 and jump_boost_multiplier == 1.0:
			animated_sprite.play("run_white_right")
			animated_sprite.flip_h = true
		elif velocity.x < 0:
			animated_sprite.play("run_rainbow_right")
			animated_sprite.flip_h = true
		elif velocity.x == 0:
			if jump_boost_multiplier == 1.0:
				animated_sprite.play("idle_white")
			else:
				animated_sprite.play("idle_color")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_boost_multiplier
		$AudioStreamPlayer2DJumper.play()
		#jumpingflag = true

	
		if velocity.y <= -180 and jump_boost_multiplier == 1.0:
			animated_sprite.play("white_jump")
		elif velocity.y <= -180:
			animated_sprite.play("rainbow_jump")

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
