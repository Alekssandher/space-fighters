extends Node2D

@export var speed: float = 90
@export var anim: AnimationPlayer

func _ready() -> void:
	anim.play("rotate")
	
func _process(delta: float) -> void:
	global_position += -transform.y * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
