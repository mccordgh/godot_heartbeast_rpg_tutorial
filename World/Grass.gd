extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grass_effect = load("res://Effects/GrassEffect.tscn")
		var grass_effect_instance = grass_effect.instance()
		var world = get_tree().current_scene

		grass_effect_instance.global_position = global_position
		world.add_child(grass_effect_instance)
		
		queue_free()
