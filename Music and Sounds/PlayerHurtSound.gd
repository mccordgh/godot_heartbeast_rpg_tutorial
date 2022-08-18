extends AudioStreamPlayer


func _ready():
	volume_db = -69
	pitch_scale = rand_range(1, 1.25)


func _on_PlayerHurtSound_finished():
	queue_free()
