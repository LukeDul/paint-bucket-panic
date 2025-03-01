extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -200.0
var jump_boost_multiplier = 1.0
@export var max_y: int 
@onready var score = $Camera2D/Label
@onready var animated_sprite = $AnimatedSprite2D
# Remove var flag = false (no longer needed)

func _ready():
	max_y = position.y

func _process(delta: float):
	if position.y < max_y: max_y = position.y
	score.text = "Score: %s" % (abs(max_y) - 33)
	
	# Use jump_boost_multiplier to determine animation state
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

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if velocity.y > 0: velocity += Vector2(0, 400) * delta
		else: velocity += Vector2(0, 980) * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * jump_boost_multiplier
		$AudioStreamPlayer2D.play()
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
