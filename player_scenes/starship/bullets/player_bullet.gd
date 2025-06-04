extends Area2D

@export var speed: float = 300.0;
@export var explosion_particle: PackedScene
@export var bullet_damage: int = 1

func _process(delta: float) -> void:
	position.y -= speed * delta;
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		var explosion_particle_instance: GPUParticles2D = explosion_particle.instantiate()
		explosion_particle_instance.position = global_position
		explosion_particle_instance.rotation = global_rotation
		
		var colors: Array[Color] = []
		
		var parent: Node2D = area.get_parent()
		colors = parent.get("base_colors")
		
		if colors is Array and colors.size() > 0:
			explosion_particle_instance.self_modulate = colors[randi_range(0, colors.size() - 1 )]
			
		explosion_particle_instance.emitting = true
		
		get_tree().current_scene.add_child(explosion_particle_instance)
		
		queue_free()
