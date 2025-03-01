extends Area2D

@export var jump_boost_amount = 1.5  # Multiplier for jump height
@export var boost_duration = 5.0     # Duration in seconds
var player = null

func _ready():
	print("PowerUp spawned at: ", global_position)
	# Find the player node
	player = get_node("/root/Main/Player")  # Adjust this path to match your scene structure
	if player:
		print("Found player at: ", player.global_position)
	else:
		print("Player not found! Check the path")

func _physics_process(delta):
	if !player or !visible:
		return
		
	# Calculate distance to player
	var distance = global_position.distance_to(player.global_position)
	print("Distance to player: ", distance)
	
	# If player is very close, apply power-up
	if distance < 40:
		print("Player is close enough, applying power-up!")
		apply_power_up(player)

func apply_power_up(player):
	print("Applying power-up to player")

	# Apply jump boost
	player.jump_boost_multiplier = jump_boost_amount
	player.modulate = Color(0.5, 1.0, 0.5)  # Green glow
	
	# Create a timer to reset
	var timer = Timer.new()
	player.add_child(timer)
	timer.wait_time = boost_duration
	timer.one_shot = true
	timer.timeout.connect(func():
		player.jump_boost_multiplier = 1.0
		player.modulate = Color(1, 1, 1)  # Normal color
		print("Jump boost expired")
		timer.queue_free()
	)
	timer.start()
	
	# Hide and queue_free
	visible = false
	set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	queue_free()
