extends Node2D

@export_category("Blasters")
@export var blasters: Array[Marker2D]
@export var fire_rate: float
@export var bullet_scene: PackedScene
@export var explosive_scene: PackedScene

@export_category("Outro")
@export var ext_node: Node2D
@export var normal_timer: Timer
@export var explosives_timer: Timer


enum State {
	SHOOTING, 
	WAITING
}

var current_state: State = State.WAITING
var hail_num: int 

func _ready() -> void:
	ext_node.connect("attack", Callable(self, "_on_moving_started"))
	

func change_state(new_state: State) -> void:
	current_state = new_state
	match  current_state:
		State.WAITING:
			pass
		State.SHOOTING:
			shoot()
			
func _on_moving_started(_hail_num: int) -> void:
	hail_num = _hail_num
	change_state(State.SHOOTING)

func shoot() -> void:
	if (hail_num % 2) > 0:
		shoot_normal()
	else:
		shoot_explosive()
	
func shoot_normal() -> void:
	add_bullet(bullet_scene, blasters[0].global_position)
	add_bullet(bullet_scene, blasters[1].global_position)
	for i: int in range(5):
		
		normal_timer.start()
		await normal_timer.timeout
		print("shoot_normal")
		add_bullet(bullet_scene, blasters[0].global_position)
		add_bullet(bullet_scene, blasters[1].global_position)
	pass
	
func shoot_explosive() -> void:
	add_bullet(explosive_scene, blasters[2].global_position)
	add_bullet(explosive_scene, blasters[3].global_position)
	
	for i: int in range(4):
		
		explosives_timer.start()
		await explosives_timer.timeout
		add_bullet(explosive_scene, blasters[2].global_position)
		add_bullet(explosive_scene, blasters[3].global_position)
		print("shoot_explosive")
	pass
	
func add_bullet(_bullet_scene: PackedScene, _blaster_pos: Vector2) -> void:
	var bullet: Node2D = _bullet_scene.instantiate()
	bullet.global_position = _blaster_pos
	get_tree().current_scene.add_child(bullet)
