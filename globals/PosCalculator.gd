extends Node

func calculate_launch_point() -> Vector2:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var random_x: float = randf_range(0, screen_size.x)
	
	var random_y: float = randf_range(0, screen_size.y * 0.2)
	
	return Vector2(random_x, random_y)
