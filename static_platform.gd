extends Node2D

@export var platform_width = 200.0  # Width of each platform
@export var platform_height = 20.0  # Height of each platform (match your StaticPlatform.tscn)
@export var screen_width = 1920.0   # Width of the screen (1920 for 1920x1080)
@onready var platform_template = $StaticPlatformTemplate  # Reference to the platform instance
var max_player_height = 0.0  # Track the highest y-position the player has reached
var platforms = []  # Array to store spawned platforms
@onready var player = get_parent().get_node("Player")  # Reference to the player
const JUMP_HEIGHT = 200.0  # Approximate jump height based on JUMP_VELOCITY = -200, gravity ~980 (adjust as needed)

# Score-related variables
var score = 0
@export var score_multiplier = 10  # Points per unit of height (adjust as needed)
@onready var score_label = $CanvasLayer/ScoreLabel

# Rising paint variables
@export var paint_rise_speed = 20.0  # Speed at which paint rises (pixels per second)
@onready var paint = $Paint
var paint_start_position = Vector2.ZERO

func _ready():
	platform_template.visible = false  # Hide the template
	
	# Initialize UI
	if score_label:
		score_label.text = "Score: 0"
	
	# Initialize paint
	if paint:
		paint_start_position = paint.position
	
	if player:
		# Initialize max height with player's starting position
		max_player_height = player.position.y
		spawn_initial_platforms()
	else:
		print("Error: Player node not found!")

func _process(delta):
	if player:
		# Update max_player_height (only goes up, not down)
		var previous_max_height = max_player_height
		max_player_height = min(max_player_height, player.position.y)  # Use min to ensure it only decreases (moves up in y terms)
		
		# Update score if player has moved upward
		if max_player_height < previous_max_height:
			var height_difference = previous_max_height - max_player_height
			score += int(height_difference * score_multiplier)
			update_score_display()
		
		# Move paint upward
		if paint:
			paint.position.y -= paint_rise_speed * delta
			
			# Check for game over
			if player.position.y > paint.position.y:
				game_over()
		
		# Spawn platforms if needed (spawning line is at max_player_height - spawn_offset)
		var spawn_y = max_player_height - (JUMP_HEIGHT / 2 + randf() * (JUMP_HEIGHT / 2))  # Random height between half and full jump height above max
		if platforms.size() == 0 or (platforms[-1].position.y < spawn_y and can_spawn_at_y(spawn_y)):
			spawn_platform(spawn_y)
		
		# Cleanup platforms that are too far below
		cleanup_platforms()

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
	
	# Randomly color the platform
	var platform_colors = [
		Color(1, 0, 0),  # Red
		Color(0, 1, 0),  # Green
		Color(0, 0, 1),  # Blue
		Color(1, 1, 0),  # Yellow
		Color(1, 0, 1),  # Magenta
		Color(0, 1, 1)   # Cyan
	]
	var color_sprite = new_platform.get_node_or_null("ColorRect")
	if color_sprite:
		color_sprite.color = platform_colors[randi() % platform_colors.size()]

func can_spawn_at_y(y_pos: float) -> bool:
	# Check if a platform can spawn at this y position (not at or below existing platforms)
	for platform in platforms:
		if platform.position.y <= y_pos + platform_height / 2:  # Allow some overlap vertically for gameplay
			return false
	return true

func cleanup_platforms():
	# Remove platforms that are too far below the player (beyond screen limit)
	var screen_bottom = max_player_height + 1080  # Assuming 1080p height
	var i = 0
	while i < platforms.size():
		if platforms[i].position.y > screen_bottom:
			platforms[i].queue_free()
			platforms.remove_at(i)
		else:
			i += 1

func update_score_display():
	if score_label:
		score_label.text = "Score: " + str(score)

func game_over():
	# Pause the game
	get_tree().paused = true
	
	# Show game over UI
	if has_node("CanvasLayer/GameOverPanel"):
		var game_over_panel = $CanvasLayer/GameOverPanel
		game_over_panel.visible = true
		
		# Update final score
		var final_score_label = game_over_panel.get_node_or_null("FinalScoreLabel")
		if final_score_label:
			final_score_label.text = "Final Score: " + str(score)

func _on_restart_button_pressed():
	# Restart the game
	get_tree().paused = false
	get_tree().reload_current_scene()
