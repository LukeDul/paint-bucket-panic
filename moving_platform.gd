extends CharacterBody2D

var move_y = false
@onready var SPEED = randi_range(5, 20)
@export var range = 30
@onready var anim = $AnimatedSprite2D

var origin
var end 
var moving_right: bool = true

func _ready():
	var types = ["a", "b", "c", "d","e"]
	anim.animation = types.pick_random()
	anim.play()
	
	origin = position.x
	end = position.x + 20
	velocity.x = SPEED


func _physics_process(delta: float) -> void:
	if position.x < origin: velocity.x = SPEED * 1 	
	elif position.x > end: velocity.x = SPEED * -1

	move_and_slide()
