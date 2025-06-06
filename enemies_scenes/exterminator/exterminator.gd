extends Node2D

@export_category("Blasters")
@export var blasters: Array[Marker2D]
@export var fire_rate: float
@export var bullet_scene: PackedScene

@export_category("Cordinates")
@export var spawn_pos: Vector2 = Vector2(0, -150)
@export var launch_pos: Vector2
@export var side: bool

@export_category("Outro")
@export var animated_sprite: AnimatedSprite2D
@export var timer: Timer

enum State {
	ENTERING, 
	IDLE,
	MOVING,
	DEAD
}

var screen_size: Vector2
var current_state: State
var tween: Tween

func _ready() -> void:
	screen_size = get_viewport_rect().size;
	
	global_position = spawn_pos
	launch_pos = global_position * Vector2(1, -0.3)
	
	change_state(State.ENTERING)

func _process(delta: float) -> void:
	match current_state:
		State.ENTERING:
			pass
		State.MOVING:
			move_laterally(delta)
		State.DEAD:
			queue_free()
			
func change_state(new_state: State) -> void:
	current_state = new_state
	
	match new_state:
		State.ENTERING:
			enter_scene()
		State.IDLE:
			pause()
		State.MOVING:
			start_shooting()
		State.DEAD:
			explode()

func enter_scene() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", launch_pos, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	
	current_state = State.MOVING
	pass

func move_laterally(_delta: float) -> void:
	if (screen_size / 2) > global_position:
		print("left side")
	else:
		print("right side")
	pass
func pause() -> void:
	pass
	
func start_shooting() -> void:
	
	print("moving")
	pass
	
func explode() -> void:
	pass
