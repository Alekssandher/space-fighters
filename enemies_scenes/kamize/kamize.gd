extends Node2D

var tween: Tween
var _tween3: Tween

@export_category("Status")
@export var health: int = 6
@export var base_colors: Array[Color]
@export var launch_point: Vector2
@export var damage: int = 1

@export_category("Nodes")
@export var anim: AnimationPlayer
@export var sprite: Sprite2D
@export var explosion_particle: PackedScene
@export var damage_area: Area2D

func _ready() -> void:

	anim.play("going_slow")
	tween = get_tree().create_tween()
	
	if launch_point == Vector2(0, 0):
		launch_point = calculate_launch_point()
	look_at(launch_point)
	tween.tween_property(self, "global_position", launch_point, 3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	anim.stop()
	sprite.frame = 0
	
	print("calld point to player")
	point_to_player()
	
	pass
	
func _process(_delta: float) -> void:
	pass
	
func calculate_launch_point() -> Vector2:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var random_x: float = randf_range(0, screen_size.x)
	
	var random_y: float = randf_range(0, screen_size.y * 0.2)
	
	return Vector2(random_x, random_y)

func point_to_player() -> void:
	var _tween: Tween = get_tree().create_tween()
	
	var player: Node2D = get_tree().get_first_node_in_group("player")
	var last_player_pos: Vector2 = player.global_position
	var dir:  Vector2 = last_player_pos - self.global_position
	var target_angle: float = dir.angle() 

	_tween.tween_property(self, "rotation", target_angle, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await _tween.finished
	
	anim.play("start_going_fast")
	
	var _tween_2: Tween = get_tree().create_tween()
	_tween_2.tween_property(self, "global_position", last_player_pos, 0.7).set_trans(Tween.TRANS_SINE)
	
	await _tween_2.finished
	explode()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start_going_fast":
		anim.play("going_fast")

func explode(explosion_scale: Vector2 = Vector2(0.55, 0.55)) -> void:
	
	var explosion_particle_instance: GPUParticles2D = explosion_particle.instantiate()
	explosion_particle_instance.position = global_position
	explosion_particle_instance.rotation = global_rotation
	
	explosion_particle_instance.scale = explosion_scale
	explosion_particle_instance.self_modulate = base_colors[randi_range(0, base_colors.size() - 1 )]
	explosion_particle_instance.modulate = Color(1, 1, 1, 1)
	explosion_particle_instance.emitting = true
	get_tree().current_scene.add_child(explosion_particle_instance)
	
	apply_damage()
	queue_free()
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		explode()
	
	if area.is_in_group("player_bullet"):
		
		health -= area.get("bullet_damage")
		if health <= 0:
			explode(Vector2(0.4, 0.4))
		if _tween3 && _tween3.is_running():
			_tween3.kill()
			
		_tween3 = get_tree().create_tween()
		_tween3.tween_property(sprite, "modulate", Color(1, 1, 1, 0.4), 0.06).set_trans(Tween.TRANS_LINEAR)
		_tween3.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.06).set_trans(Tween.TRANS_LINEAR)

func apply_damage() -> void:
	damage_area.process_mode = Node.PROCESS_MODE_INHERIT
	
func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		GlobalSignals.emit_signal("player_took_damage", damage)
