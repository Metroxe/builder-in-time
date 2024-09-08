extends Area2D

@export var fall_speed: float = 100.0
@export var sprite_options: Array[Texture2D] = [
	preload("res://art/zeus_0.png"),
	preload("res://art/zeus_1.png"),
	preload("res://art/zeus_2.png")
]

var screen_size: Vector2
@onready var sprite: Sprite2D = $Sprite2D

signal collected(building)

var is_collected: bool = false
var collected_position: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	# Choose a random sprite
	if sprite_options.size() > 0:
		sprite.texture = sprite_options[randi() % sprite_options.size()]
	
	# Set initial position at the top of the screen with random x coordinate
	position.x = randf_range(0, screen_size.x)
	position.y = -50  # Start above the screen

	# Adjust the scale of the sprite
	sprite.scale = Vector2(0.25, 0.25)  # Adjust this value as needed

func _process(delta: float) -> void:
	if not is_collected:
		# Fall down
		position.y += fall_speed * delta
		
		# Check if out of screen
		if position.y > screen_size.y + 50:
			queue_free()
	else:
		# Move towards the collected position
		position = position.move_toward(collected_position, fall_speed * delta)

func _on_area_entered(area: Area2D) -> void:
	print("building entered1", is_collected, area.is_in_group("player"))
	if area.is_in_group("player") and not is_collected:
		print("building entered2")
		is_collected = true
		emit_signal("collected", self)

func set_collected_position(new_position: Vector2) -> void:
	collected_position = new_position
