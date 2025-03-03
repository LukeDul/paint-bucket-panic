extends Node2D

const PLATFORM_Y_STEP = 40
const PLATFORM_Y_LOWER_BOUND = 10
const PLATFORM_Y_UPPER_BOUND = 20
const PLATFORM_X_LOWER_BOUND = -15
const PLATFORM_X_UPPER_BOUND = 15

var last_height # tracks the players last height 

@onready var player = $Player
@onready var random_step = calc_random_step()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_height = player.position.y
	
	$AudioStreamPlayer2DMusic.play()	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.position.y < last_height - random_step: # if the player is higher than he was last frame + [10-20]
		_gen_new_platform(randi_range(PLATFORM_X_LOWER_BOUND, PLATFORM_X_UPPER_BOUND), player.position.y - PLATFORM_Y_STEP) 
		
		last_height = player.position.y
		random_step = calc_random_step()


func calc_random_step()->int: 
	"""Returns a value between PLATFORM_Y_LOWER_BOUND and PLATFORM_Y_UPPER_BOUND"""
	return randi_range(PLATFORM_Y_LOWER_BOUND, PLATFORM_Y_UPPER_BOUND) 


func _gen_new_platform(x: float, y: int) -> void:
	"""Places a platform of random type at the coords"""
	var platform_type = randi() % 2  # Randomly choose 0 or 1
	var scene_path = ""
	
	if platform_type == 0: scene_path = "res://static platform.tscn"
	else: scene_path = "res://moving_platform.tscn"
	
	var scene = load(scene_path) 
	var instance = scene.instantiate() 
	instance.position = Vector2(x, y)  
	self.add_child(instance) 
	
	# Spawn power-up with a 10% chance (increased for testing)
	if randf() < 0.1:
		var power_up_scene = preload("res://PowerUp.tscn") 
		var power_up = power_up_scene.instantiate()
		power_up.position = Vector2(x, y - 30)  # Position above platform
		add_child(power_up)
