extends Area2D
var initial_speed = 3.0        # Increased starting speed (was 1.0)
var acceleration = 3.0        # Increased acceleration rate (was 1.0)
var max_speed = 36.0        # Increased maximum speed (was 20.0)
var current_speed = 0.0
var paint_height = 20.0        # Current height in pixels (grows upward)
var distance_multiplier = 0.0  # Additional speed based on distance from player
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var player = null     # Will store reference to player

# only start moving once the player starts moving?
func _ready():
	current_speed = initial_speed
	
	# Set initial sizes and positions
	collision_shape.shape.extents.y = paint_height / 2
	sprite.scale.y = paint_height / sprite.texture.get_height()  # Scale to initial height
	collision_shape.position.y = -paint_height / 2  
	sprite.position.y = -paint_height / 2
	
	# Get reference to player
	player = get_node("/root/Main/Player")  # Adjust this path to match your scene structure

func _process(delta):
	# Calculate distance-based multiplier
	if player:
		var paint_top = global_position.y - paint_height
		var player_bottom = player.global_position.y  # Assuming this is the player's feet position
		
		var distance = player_bottom - paint_top
		
		# More aggressive distance multiplier
		distance_multiplier = clamp(distance / 5.0, 1.0, 8.0)  # Steeper scaling
	else:
		distance_multiplier = 1.0
	
	# Accelerate the growth rate
	current_speed = min(current_speed + acceleration * delta, max_speed)
	
	# Apply distance multiplier to the current frame's movement
	var frame_speed = current_speed * distance_multiplier
	
	# Increase paint height (grows upward)
	paint_height += frame_speed * delta
	
	# Update collision shape
	collision_shape.shape.extents.y = paint_height / 2
	collision_shape.position.y = -paint_height / 2  # Keep bottom anchored
	
	# Update sprite
	sprite.scale.y = paint_height / sprite.texture.get_height()  # Stretch vertically
	sprite.position.y = -paint_height / 2  # Keep bottom anchored
	
func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == 'Player':
		print("Game Over! Paint caught the player.")
		get_tree().reload_current_scene()
