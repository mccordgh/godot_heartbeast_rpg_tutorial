extends KinematicBody2D


const enemy_death_effect = preload("res://Effects/EnemyDeathEffect.tscn")


export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200


enum {
	IDLE,
	PATROL,
	CHASE
}


var state = CHASE
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

onready var hurtbox = $Hurtbox
onready var player_detection_zone = $PlayerDetectionZone
onready var stats = $Stats
onready var soft_collision = $SoftCollision
onready var sprite = $AnimatedSprite


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		PATROL:
			pass
		
		CHASE:
			var player = player_detection_zone.player
			sprite.flip_h = velocity.x < 0
			
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400					
	
	velocity = move_and_slide(velocity)
	
	
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
	

func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 120
	stats.health -= area.damage
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	
	var enemy_death_effect_instance = enemy_death_effect.instance()
	enemy_death_effect_instance.global_position = global_position
	
	get_parent().add_child(enemy_death_effect_instance)
	

