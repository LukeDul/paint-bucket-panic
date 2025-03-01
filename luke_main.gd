extends Node2D
var player
var last_height 
var random_step

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Player")
	last_height = player.position.y
	random_step = calc_random_step()
	
	
func calc_random_step()->int: return randi_range(10, 20) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# gen random num [30-50] and store it
	# store current height of player as last height 
	# if our current height is the last height + rand
	print(player.max_y)
	
	
	if player.position.y < last_height - random_step:
		_gen_new_platforms(randi_range(-10, 10), player.position.y - 10)
		last_height = player.position.y
		random_step = calc_random_step()
		
	
	
func _gen_new_platforms(x: int, y: int) -> void:
	var scene = load("res://static platform.tscn")  # Load the scene at runtime
	var instance = scene.instantiate()  # Create an instance of the scene
	instance.position = Vector2(x, y)  # Set the position
	add_child(instance)  # Add it to the current node
	pass
	
