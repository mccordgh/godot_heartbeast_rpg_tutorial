extends Node2D


func create_grass_effect():
	var grass_effect = load("res://Effects/GrassEffect.tscn")
	var grass_effect_instance = grass_effect.instance()
	var world = get_tree().current_scene

	grass_effect_instance.global_position = global_position
	world.add_child(grass_effect_instance)


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
