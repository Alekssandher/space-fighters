extends Node2D

@export var shoot_cooldown: float = 0.3             
@export var sprites: Sprite2D

@export var anim: AnimationPlayer

@export var bullet_scene: PackedScene


@export var blaster_1: Marker2D
@export var blaster_2: Marker2D

var can_shoot: bool = true

func _ready() -> void:
	anim.play("idle")
	pass
	
func _process(_delta: float) -> void:
	
	if (Input.is_action_just_pressed("shoot") or Input.is_action_pressed("shoot")) && can_shoot:
		shoot()
		wait(shoot_cooldown)
		
func shoot() -> void:
	anim.play("shooting")
	var bullet_1: Node2D = bullet_scene.instantiate();
	var bullet_2: Node2D = bullet_scene.instantiate();
	
	bullet_1.global_position = blaster_1.global_position
	bullet_2.global_position = blaster_2.global_position
	
	get_tree().current_scene.add_child(bullet_1)
	get_tree().current_scene.add_child(bullet_2)
	pass

func wait(seconds: float) -> void:
	can_shoot = false
	await get_tree().create_timer(seconds).timeout
	can_shoot = true
