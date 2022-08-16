extends Area2D


export(bool) var show_hit_effect = true


var hit_effect = preload("res://Effects/HitEffect.tscn")


func _on_Hurtbox_area_entered(area):
	if show_hit_effect:
		var effect_instance = hit_effect.instance()
		var current_scene = get_tree().current_scene
		
		effect_instance.global_position = global_position
		current_scene.add_child(effect_instance)
	
