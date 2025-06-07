extends Node2D

var tween: Tween
var _tween3: Tween

@export_category("Status")
@export var health: int = 6
@export var base_colors: Array[Color]
@export var launch_point: Vector2
@export var damage: int = 1

@export_category("Nodes")
@export var sprite: Sprite2D
@export var explosion_particle: PackedScene
@export var damage_area: Area2D
@export var gpu_part: GPUParticles2D

var calc: GlobalPosCalculator = GlobalPosCalculator
func _ready() -> void:

	tween = get_tree().create_tween()
	
	if launch_point == Vector2(0, 0):
		launch_point = calc.calculate_launch_point()
	look_at(launch_point)
	tween.tween_property(self, "global_position", launch_point, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
	sprite.frame = 0
	
	tween.kill()
	point_to_player()
	

func point_to_player() -> void:
	var _tween: Tween = get_tree().create_tween()
	
	var player: Node2D = get_tree().get_first_node_in_group("player")
	
	if(!player): 
		return
	var last_player_pos: Vector2 = player.global_position
	var dir:  Vector2 = last_player_pos - self.global_position
	var target_angle: float = dir.angle() 

	_tween.tween_property(self, "rotation", target_angle, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await _tween.finished
	
	var _tween_2: Tween = get_tree().create_tween()
	
	_tween_2.tween_property(self, "global_position", last_player_pos, 0.5).set_trans(Tween.TRANS_SINE)
	gpu_part.scale = gpu_part.scale + Vector2(0.4, 0)
	
	await _tween_2.finished
	explode()

func explode(explosion_scale: Vector2 = Vector2(0.55, 0.55)) -> void:
	
	var explosion_particle_instance: GPUParticles2D = explosion_particle.instantiate()
	explosion_particle_instance.position = global_position
	explosion_particle_instance.rotation = global_rotation
	
	explosion_particle_instance.scale = explosion_scale
	
	explosion_particle_instance.emitting = true
	var mat: ParticleProcessMaterial = explosion_particle_instance.process_material
	
	var gradient: Gradient = Gradient.new()
	gradient.add_point(0.0, base_colors[0])
	gradient.add_point(1.0, base_colors[1])
	
	var gradient_texture : GradientTexture1D = GradientTexture1D.new()
	gradient_texture.gradient = gradient
	mat.color_ramp = gradient_texture
	
	
	get_tree().current_scene.add_child(explosion_particle_instance)
	
	apply_damage()
	queue_free()


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
