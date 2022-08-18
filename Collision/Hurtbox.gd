extends Area2D

onready var collision_shape = $CollisionShape2D
onready var timer = $InvincibleTimer


const hit_effect = preload("res://Effects/HitEffect.tscn")


var invincible = false setget set_invincible


signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
	
	
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

	
func create_hit_effect():
	var effect_instance = hit_effect.instance()
	var current_scene = get_tree().current_scene
	
	effect_instance.global_position = global_position
	current_scene.add_child(effect_instance)
	

func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)
	collision_shape.set_deferred("disabled", true)


func _on_Hurtbox_invincibility_ended():
	monitoring = true
	collision_shape.disabled = false
