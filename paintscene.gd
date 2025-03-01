extends Area2D

@export var initial_speed = 50.0  # Starting height increase rate (pixels per second, upward)
@export var acceleration = 10.0   # Rate increase per second
@export var max_speed = 200.0     # Max height increase rate
var current_speed = 0.0
var paint_height = 100.0          # Current height in pixels (grows upward)
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	current_speed = initial_speed
	connect("body_entered", _on_body_entered)
	# Set initial sizes and positions
	collision_shape.shape.extents.y = paint_height / 2
	sprite.scale.y = paint_height / sprite.texture.get_height()  # Scale to 100px height
	collision_shape.position.y = -paint_height / 2  # Bottom at y = 1080
	sprite.position.y = -paint_height / 2  # Bottom at y = 1080

func _process(delta):
	# Accelerate the growth rate
	current_speed = min(current_speed + acceleration * delta, max_speed)
	# Increase paint height (grows upward)
	paint_height += current_speed * delta
	# Update collision shape
	collision_shape.shape.extents.y = paint_height / 2
	collision_shape.position.y = -paint_height / 2  # Keep bottom anchored at y = 1080
	# Update sprite
	sprite.scale.y = paint_height / sprite.texture.get_height()  # Stretch vertically
	sprite.position.y = -paint_height / 2  # Keep bottom anchored at y = 1080
	# Cap height at screen size (1080px from bottom to top)
	if paint_height >= 1080:
		paint_height = 1080
		current_speed = 0  # Stop growing when full

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Game Over! Paint caught the player.")
		get_tree().reload_current_scene()s
