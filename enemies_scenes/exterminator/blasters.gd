extends Node2D

@export_category("Blasters")
@export var blasters: Array[Marker2D]
@export var fire_rate: float
@export var bullet_scene: PackedScene

@export var ext_node: Node2D
@export var timer: Timer

enum State {
	SHOOTING, 
	WAITING
}

var current_state: State = State.WAITING
var hail_num: int 

func _ready() -> void:
	ext_node.connect("attack", Callable(self, "_on_moving_started"))
	

func _process(_delta: float) -> void:
	match  current_state:
		State.WAITING:
			pass
		State.SHOOTING:
			shoot()
			
func _on_moving_started(_hail_num: int) -> void:
	hail_num = _hail_num

func shoot() -> void:
	if (hail_num % 2) > 0:
		shoot_normal()
	else:
		shoot_explosive()
	
func shoot_normal() -> void:
	pass
	
func shoot_explosive() -> void:
	pass
