extends StaticBody2D
@onready var anim = $AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var types = ["a", "b", "c", "d","e"]
	anim.animation = types.pick_random()
	anim.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
