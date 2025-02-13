extends Area2D

@export var explosion: PackedScene = preload("res://barrel/explosion.tscn")

var damage := 0

signal explo_damage(int)

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	spawn_explosion()
	apply_explosion_impulse()

func spawn_explosion():
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = global_position
	explosion_instance.rotation = global_rotation
	explosion_instance.emitting = true
	get_tree().current_scene.add_child(explosion_instance)
	queue_free() 


func apply_explosion_impulse():
	var kill_radius: float = 30.0   
	var push_radius: float = 50.0  
	var impulse_power: float = 200.0
	
	for node in get_parent().get_children():
		if node is RigidBody2D:
			var direction = node.global_position - global_position
			var distance = direction.length()

			if distance < kill_radius:
				node.queue_free()
			elif distance < push_radius:
				node.apply_central_impulse(direction.normalized() * impulse_power)
				
		elif node is Area2D or node is StaticBody2D:
			var direction = node.global_position - global_position
			var distance = direction.length()
			if distance < kill_radius:
				node.queue_free()
		elif node is CharacterBody2D:
			var direction = node.global_position - global_position
			var distance = direction.length()
			if distance < 20:
				emit_signal("explo_damage", 200)
			elif distance < 25:
				emit_signal("explo_damage", 99)
			elif distance < 30:
				emit_signal("explo_damage", 60)
			elif distance < 50:
				emit_signal("explo_damage", 40)
