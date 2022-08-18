extends AnimatedSprite


onready var audio_stream_player = $AudioStreamPlayer


func _ready():
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	
	audio_stream_player.pitch_scale = rand_range(1, 1.25)
	
	play("Animate")


func _on_AnimatedSprite_animation_finished():
	queue_free()
