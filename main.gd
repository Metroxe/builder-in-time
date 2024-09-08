extends Node2D

@export var building_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var bottom_margin: float = 50.0
@export var building_spacing: float = 70.0

var screen_size: Vector2
var collected_buildings: Array = []

func _ready() -> void:
	screen_size = get_viewport_rect().size
	$SpawnTimer.wait_time = spawn_interval
	$Button.connect("pressed", Callable(self, "_on_Button_pressed"))

func _on_Button_pressed() -> void:
	$SpawnTimer.start()
	$Button.hide()  # Optionally hide the button after starting the game

func _on_spawn_timer_timeout() -> void:
	if collected_buildings.size() * building_spacing < screen_size.x:
		var building = building_scene.instantiate()
		add_child(building)
		building.collected.connect(_on_building_collected)
	else:
		$SpawnTimer.stop()
		$MessageLabel.text = "You found yourself in your new city, good job!"
		$MessageLabel.show()
		$PlayAgainButton.show()

func _on_building_collected(building: Area2D) -> void:
	collected_buildings.append(building)
	arrange_collected_buildings()

func arrange_collected_buildings() -> void:
	var start_x = building_spacing / 2
	for i in range(collected_buildings.size()):
		var building = collected_buildings[i]
		var new_position = Vector2(
			start_x + i * building_spacing,
			screen_size.y - bottom_margin
		)
		building.set_collected_position(new_position)

func _on_PlayAgainButton_pressed() -> void:
	for building in collected_buildings:
		building.queue_free()
	collected_buildings.clear()
	$MessageLabel.hide()
	$PlayAgainButton.hide()
	$Button.show()
