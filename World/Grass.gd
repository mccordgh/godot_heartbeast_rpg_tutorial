extends Node2D


const grass_effect = preload("res://Effects/GrassEffect.tscn")


func create_grass_effect():
	var grass_effect_instance = grass_effect.instance()

	grass_effect_instance.global_position = global_position
	get_parent().add_child(grass_effect_instance)


func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
