extends Node2D

@export var kamize_scene: PackedScene
@export var cooldown: float
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size;
	spawn_loop()
	
func spawn_loop() -> void:
	while true:
		await get_tree().create_timer(cooldown).timeout
		spawn_kamize(calc_spawn())
	
func calc_spawn() -> Vector2:
	return screen_size / 2 + Vector2(randf_range(-20, 20), -350)
	
func spawn_kamize(location: Vector2) -> void:
	
	var kamize_inst: Node2D = kamize_scene.instantiate()
	
	kamize_inst.global_position = location
	
	get_tree().current_scene.add_child(kamize_inst)
