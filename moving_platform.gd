extends CharacterBody2D

var move_y = false
@export var SPEED = 5.0
@export var range = 30

var origin
var end 
var moving_right: bool = true

func _ready():
	origin = position.x
	end = position.x + 10
	velocity.x = SPEED


func _physics_process(delta: float) -> void:
	if position.x < origin: velocity.x = SPEED * 1 	
	elif position.x > end: velocity.x = SPEED * -1

	move_and_slide()
