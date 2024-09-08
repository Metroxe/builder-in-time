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
	$SpawnTimer.start()

func _on_spawn_timer_timeout() -> void:
	var building = building_scene.instantiate()
	add_child(building)
	building.collected.connect(_on_building_collected)

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
