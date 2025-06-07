extends Node2D

@export_category("Cordinates")
@export var spawn_pos: Vector2 = Vector2(0, -150)
@export var launch_pos: Vector2
@export var side: bool

@export_category("Outro")
@export var animated_sprite: AnimatedSprite2D


enum State {
	ENTERING, 
	IDLE,
	MOVING,
	WAITING,
	DEAD
}

var screen_size: Vector2
var current_state: State
var tween: Tween

var hail_num: int = 0

signal attack
signal stop_attack

func _ready() -> void:
	screen_size = get_viewport_rect().size;
	
	global_position = spawn_pos
	launch_pos = global_position * Vector2(1, -0.3)
	
	change_state(State.ENTERING)

func change_state(new_state: State) -> void:
	current_state = new_state
	
	match new_state:
		State.ENTERING:
			enter_scene()
		State.WAITING:
			wait()
		State.MOVING:
			move_laterally()
		State.DEAD:
			explode()

func enter_scene() -> void:
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", launch_pos, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	
	tween.kill()
	
	change_state(State.MOVING)
	pass

func move_laterally() -> void:
	tween = get_tree().create_tween()
	
	var target_x: float 
	var target_pos: Vector2 
	
	if (screen_size / 2) > global_position:
		target_x = global_position.x - screen_size.x * -0.8
		target_pos = Vector2(target_x, global_position.y)
		tween.tween_property(self, "global_position", target_pos, 3)
		animated_sprite.play("move")
		animated_sprite.flip_h = false
	else:
		target_x = global_position.x - screen_size.x * 0.8
		target_pos = Vector2(target_x, global_position.y)
		tween.tween_property(self, "global_position", target_pos, 3)
		animated_sprite.play("move")
		animated_sprite.flip_h = true
		
	hail_num += 1 
	attack.emit(hail_num)
	
	await tween.finished
	
	stop_attack.emit()
	change_state(State.WAITING)
	pass
func wait() -> void:
	change_state(State.MOVING)

func explode() -> void:
	pass
