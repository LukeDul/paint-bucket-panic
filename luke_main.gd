extends Node2D
var player
var last_height 
var random_step

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	last_height = player.position.y
	random_step = calc_random_step()
	PhysicsServer2D.set_active(true)
	$AudioStreamPlayer2D.play()	
func calc_random_step()->int: return randi_range(10, 20) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# gen random num [30-50] and store it
	# store current height of player as last height 
	# if our current height is the last height + rand
	
	
	if player.position.y < last_height - random_step:
		_gen_new_platforms(randi_range(-10, 10), player.position.y - 40)
		last_height = player.position.y
		random_step = calc_random_step()
		
# Add at the top of your platform generator script
var power_up_scene = preload("res://PowerUp.tscn")  # Update this path

# In your _gen_new_platforms function
func _gen_new_platforms(x: float, y: int) -> void:
	var platform_type = randi() % 2  # Randomly choose 0 or 1
	var scene_path = ""
	
	if platform_type == 0:
		scene_path = "res://static platform.tscn"
	else:
		scene_path = "res://moving_platform.tscn"
	
	var scene = load(scene_path)  # Load the selected scene
	var instance = scene.instantiate()  # Create an instance
	instance.position = Vector2(x, y)  # Set the position
	add_child(instance)  # Add it to the current node
	
	# Spawn power-up with a 10% chance (increased for testing)
	if randf() < 0.1:
		print("Attempting to spawn power-up")
		var power_up = power_up_scene.instantiate()
		power_up.position = Vector2(x, y - 30)  # Position above platform
		add_child(power_up)
		print("Power-up spawned successfully")
