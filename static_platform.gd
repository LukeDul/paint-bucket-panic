extends Node2D

@export var platform_width = 200.0  # Width of each platform
@export var platform_height = 20.0  # Height of each platform (match your StaticPlatform.tscn)
@export var screen_width = 1920.0   # Width of the screen (1920 for 1920x1080)
@onready var platform_template = $StaticPlatformTemplate  # Reference to the platform instance
var max_player_height = 0.0  # Track the highest y-position the player has reached
var platforms = []  # Array to store spawned platforms
@onready var player = get_parent().get_node("Player")  # Reference to the player
@onready var score_label = $CanvasLayer/ScoreLabel
const JUMP_HEIGHT = 200.0  # Approximate jump height based on JUMP_VELOCITY = -200, gravity ~980 (adjust as needed)
var score = 0

func _ready():
	platform_template.visible = false  # Hide the template
	if player:
		# Initialize max height with player’s starting position
		max_player_height = player.position.y
		spawn_initial_platforms()
	else:
		print("Error: Player node not found!")

func _process(delta):
	if player:
		# Update max_player_height (only goes up, not down)
		max_player_height = min(max_player_height, player.position.y)  # Use min to ensure it only decreases (moves up in y terms)
		# Spawn platforms if needed (spawning line is at max_player_height - spawn_offset)
		var spawn_y = max_player_height - (JUMP_HEIGHT / 2 + randf() * (JUMP_HEIGHT / 2))  # Random height between half and full jump height above max
		if platforms.size() == 0 or (platforms[-1].position.y < spawn_y and can_spawn_at_y(spawn_y)):
			spawn_platform(spawn_y)

func spawn_initial_platforms():
	# Spawn a few platforms above the player to start
	var player_y = player.position.y
	for i in 3:  # Spawn 3 initial platforms
		var spawn_y = player_y - (JUMP_HEIGHT + i * 100)  # Start above player, spaced out
		if can_spawn_at_y(spawn_y):
			spawn_platform(spawn_y)

func spawn_platform(spawn_y: float):
	var new_platform = platform_template.duplicate()
	new_platform.visible = true
	new_platform.position = Vector2(
		randf_range(0, screen_width - platform_width),  # Random x position
		spawn_y  # y position at the spawning line
	)
	add_child(new_platform)
	platforms.append(new_platform)

func can_spawn_at_y(y_pos: float) -> bool:
	# Check if a platform can spawn at this y position (not at or below existing platforms)
	for platform in platforms:
		if platform.position.y <= y_pos + platform_height / 2:  # Allow some overlap vertically for gameplay
			return false
	return true
