extends Area2D

var initial_speed = 1.0  # Starting height increase rate (pixels per second, upward)
var acceleration = 1.0   # Rate increase per second
var max_speed = 20.0     # Max height increase rate
var current_speed = 0.0
var paint_height = 20.0          # Current height in pixels (grows upward)
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D


# only start moving once the player starts moving?
func _ready():
	current_speed = initial_speed
	
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
	

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == 'Player':
		print("Game Over! Paint caught the player.")
		get_tree().reload_current_scene()
