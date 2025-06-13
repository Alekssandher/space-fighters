extends Node2D

class_name Bullet

@export var explosion_particle: PackedScene
@export var bullet_damage: int = 1
@export var sprite: Sprite2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var explosion_particle_instance: GPUParticles2D = explosion_particle.instantiate()
		explosion_particle_instance.position = global_position
		explosion_particle_instance.rotation = global_rotation
		explosion_particle_instance.self_modulate = sprite.modulate
		
		explosion_particle_instance.emitting = true
		
		get_tree().current_scene.add_child(explosion_particle_instance)
		
		GlobalSignals.emit_signal("player_took_damage", bullet_damage)
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
