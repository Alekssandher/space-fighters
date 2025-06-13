extends Bullet

@export var speed: float = 80
@export var anim: AnimationPlayer

func _ready() -> void:
	anim.play("rotate")
	
func _process(delta: float) -> void:
	global_position += -transform.y * speed * delta
	
