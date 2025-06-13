extends Bullet

@export var anim: AnimationPlayer
@export var speed: float = 130
@export var shards_num: int = 8

@export var shard_scene: PackedScene

var screen_size: Vector2

func _ready() -> void:
	anim.play("rotate")
	screen_size = get_viewport_rect().size;
	
func _process(delta: float) -> void:
	global_position.y += speed * delta
	manage_explosion()

func manage_explosion() -> void:
	
	if global_position.y > screen_size.y * randf_range(0.9, 1):
		set_process(false)
		explode()
		
	pass
	
func get_exploded() -> void:
	add_particle()
	
func explode() -> void:
	add_particle()
	spawn_shards(shards_num)
	queue_free()

func add_particle() -> void:
	var explosion_particle_instance: GPUParticles2D = explosion_particle.instantiate()
	explosion_particle_instance.position = global_position
	explosion_particle_instance.rotation = global_rotation
	explosion_particle_instance.modulate = Color("402f9d")
	explosion_particle_instance.emitting = true
	
	get_tree().current_scene.add_child(explosion_particle_instance)
	
func spawn_shards(_shards_num: int) -> void:
	var angle_step: float = 2 * PI / _shards_num
	
	for i: int in range(_shards_num):
		
		var angle: float = i * angle_step
		var shard: Node2D = shard_scene.instantiate()
		shard.global_position = global_position
		shard.rotation = angle
		get_tree().current_scene.add_child(shard)
	
