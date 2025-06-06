extends Node2D

@export var animated_sprite: AnimatedSprite2D
@export var explosion_particles: PackedScene

var tween: Tween
func _ready() -> void:
	GlobalSignals.connect("player_took_damage", Callable(self, "_on_player_damaged"))
	
func _on_player_damaged(damage: int) -> void:

	PlayerStatus.data["health"] -= damage
	
	if PlayerStatus.data["health"] <= 0:
		explode()
	if tween && tween.is_running():
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.tween_property(animated_sprite, "modulate", Color(1.5, 1.5, 1.5, 0.4), 0.1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(animated_sprite, "modulate", Color(1, 1, 1, 1), 0.1).set_trans(Tween.TRANS_LINEAR)

func explode() -> void:
	var explosion_instance: GPUParticles2D = explosion_particles.instantiate()
	
	explosion_instance.position = global_position
	explosion_instance.rotation = global_rotation
	explosion_instance.scale = Vector2(0.35, 0.35)
	explosion_instance.lifetime = 1.25
	explosion_instance.emitting = true
	
	get_tree().current_scene.add_child(explosion_instance)
	
	get_parent().queue_free()
	
	await get_tree().create_timer(0.5).timeout
	
	
