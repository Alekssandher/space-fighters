extends Node2D

@export var anim: AnimationPlayer
@export var speed: float = 90
@export var explosion_particle: PackedScene

func _ready() -> void:
	anim.play("rotate")
	
func _process(delta: float) -> void:
	global_position.y += speed * delta

func get_exploded() -> void:
	add_particle()
	
func explode() -> void:
	add_particle()
	
	queue_free()

func add_particle() -> void:
	var explosion_particle_instance: GPUParticles2D = explosion_particle.instantiate()
	explosion_particle_instance.position = global_position
	explosion_particle_instance.rotation = global_rotation
	
	explosion_particle_instance.emitting = true
	
	get_tree().current_scene.add_child(explosion_particle_instance)
