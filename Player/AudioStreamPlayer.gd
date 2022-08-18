extends AudioStreamPlayer


func _ready():
	volume_db = -69


func _on_AudioStreamPlayer_finished():
	pitch_scale = rand_range(1, 1.25)
