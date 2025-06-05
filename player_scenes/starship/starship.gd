extends Node2D

@export var speed: float = 160;
@export var animated_sprite: AnimatedSprite2D;

var screen_size: Vector2;
var margin: Vector2 = Vector2(10, 10)

func _ready() -> void:
	screen_size = get_viewport_rect().size;
	self.global_position = screen_size / 2
	
var sprite_half_size: Vector2;
var move_dir: Vector2


func _process(delta: float) -> void:

	move_state(delta)
	
func move_state(delta: float) -> void:
	
	# -1, 0 left
	# 0, -1 up
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	global_position += move_dir * speed * delta
	
	global_position = global_position.clamp(margin, screen_size - margin)
	
	apply_anim()
	
func apply_anim() -> void:

	if move_dir.x != 0:
		animated_sprite.play("move")
		animated_sprite.flip_h = !(move_dir.x < 0)
	elif move_dir.y != 0:
		animated_sprite.play("idle")  
	else:
		animated_sprite.play("idle")
	
