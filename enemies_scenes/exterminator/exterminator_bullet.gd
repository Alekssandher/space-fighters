extends Bullet

@export var speed: float = 130
@export var damage_area: Area2D


func _process(delta: float) -> void:
	global_position.y += speed * delta
	
