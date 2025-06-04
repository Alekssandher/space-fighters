extends Node2D

@export var speed: float = 160;
@export var sprite: Sprite2D;

enum State {
	IDLE,
	MOVE
}

var state: State = State.IDLE

var screen_size: Vector2;
var margin: Vector2 = Vector2(10, 10)

func _ready() -> void:
	screen_size = get_viewport_rect().size;
	self.global_position = screen_size / 2
	
var velocity: Vector2;
var sprite_half_size: Vector2;
var dir_x: int;



func _process(delta: float) -> void:

	move_state(delta)
			
	velocity = Vector2.ZERO;

func move_state(delta: float) -> void:
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
	
	if velocity.x != 0:
		dir_x = sign(velocity.x)
	else: 
		dir_x = 0
			
	position += velocity * delta;
	position = position.clamp(margin, screen_size - margin)
	

	
	
