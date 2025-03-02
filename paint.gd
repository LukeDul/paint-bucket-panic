extends Area2D

var initial_speed = 3.0        # Increased starting speed (was 1.0)
var acceleration = 3.0        # Increased acceleration rate (was 1.0)
var max_speed = 60.0         # Increased maximum speed (was 20.0)
var current_speed = 0.0
var paint_height = 20.0       # Current height in pixels (grows upward)
var distance_multiplier = 0.0 # Additional speed based on distance from player

# Sound-related variables
var previous_distance = 0.0    # To track distance changes
var sound_threshold = 100.0    # Distance at which sound starts playing (adjust as needed)
var is_sound_playing = false   # To prevent multiple sound instances

@onready var sprite = $Sprite2D
@onready var face = $PaintFace
@onready var collision_shape = $CollisionPolygon2D
@onready var player = null     # Will store reference to player
@onready var sound_player = $AudioStreamPlayer2DBlurbNoise  # Add this line - need to add node in scene

func _ready():
	current_speed = initial_speed
	player = get_node("/root/Main/Player")  # Adjust this path to match your scene structure
	
	# Set initial distance
	if player:
		var paint_top = global_position.y - paint_height
		var player_bottom = player.global_position.y
		previous_distance = player_bottom - paint_top

func _process(delta):
	# Calculate distance-based multiplier and current distance
	var current_distance = 0.0
	if player:
		var paint_top = global_position.y - paint_height
		var player_bottom = player.global_position.y
		current_distance = player_bottom - paint_top
		
		# Sound logic
		if current_distance < sound_threshold and current_distance < previous_distance:
			if not is_sound_playing and sound_player:
				sound_player.play()
				is_sound_playing = true
		elif current_distance >= sound_threshold and is_sound_playing:
			sound_player.stop()
			is_sound_playing = false
			
		# Update previous distance
		previous_distance = current_distance
		
		# More aggressive distance multiplier
		distance_multiplier = clamp(current_distance / 5.0, 1.0, 8.0)
	else:
		distance_multiplier = 1.0
	
	# Accelerate the growth rate
	current_speed = min(current_speed + acceleration * delta, max_speed)
	
	# Apply distance multiplier to the current frame's movement
	var frame_speed = current_speed * distance_multiplier
	
	# Increase paint height (grows upward)
	paint_height += frame_speed * delta
	
	# Update sprite
	sprite.scale.y = paint_height / sprite.texture.get_height()
	sprite.position.y = -paint_height / 2
	face.position.y = -paint_height
	collision_shape.position.y = face.position.y -4

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == 'Player':
		#$AudioStreamPlayer2DDeath.play()
		get_tree().change_scene_to_file("res://death_screen.tscn")
