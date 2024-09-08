extends Area2D

@export var speed: float = 200.0
@export var screen_margin: float = 10.0

var screen_size: Vector2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		sprite.flip_h = true
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		sprite.flip_h = false
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play("walk")  # Play the "walk" animation when moving
	else:
		sprite.stop()  # Stop the animation when not moving
	
	position += velocity * delta
	position.x = clamp(position.x, screen_margin, screen_size.x - screen_margin)
