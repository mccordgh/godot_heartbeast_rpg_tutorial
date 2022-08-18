extends KinematicBody2D


const enemy_death_effect = preload("res://Effects/EnemyDeathEffect.tscn")


export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4


enum {
	IDLE,
	WANDER,
	CHASE
}


var state = CHASE
var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

onready var animation_player = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var player_detection_zone = $PlayerDetectionZone
onready var stats = $Stats
onready var soft_collision = $SoftCollision
onready var sprite = $AnimatedSprite
onready var wander_controller = $WanderController


func _ready():
	choose_state()
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			choose_state()
			
		
		WANDER:
			seek_player()
			choose_state()
			
			accelerate_toward_point(wander_controller.target_position, delta)
			
			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				state = IDLE
		
		CHASE:
			var player = player_detection_zone.player
			
			if player != null:
				accelerate_toward_point(player.global_position, delta)
			else:
				state = IDLE
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400					
	
	velocity = move_and_slide(velocity)
	
	
func choose_state():
	if wander_controller.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		
		if state == WANDER:
			wander_controller.start_wander_timer(rand_range(1, 3))
	
	
func accelerate_toward_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
			
	
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
	

func pick_random_state(state_list):
	state_list.shuffle();
	return state_list.pop_front()


func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 120
	stats.health -= area.damage
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)

func _on_Stats_no_health():
	queue_free()
	
	var enemy_death_effect_instance = enemy_death_effect.instance()
	enemy_death_effect_instance.global_position = global_position
	
	get_parent().add_child(enemy_death_effect_instance)
	

func _on_Hurtbox_invincibility_started():
	animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	animation_player.play("Stop")
