extends KinematicBody2D

const player_hurt_sound = preload("res://Music and Sounds/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 100
export var FRICTION = 400
export var ROLL_SPEED = 125

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var blink_animation_player = $BlinkAnimationPlayer
onready var hurtbox = $Hurtbox
onready var sword_hit_box = $HitboxPosition/SwordHitbox

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayersStats

func _ready():
	stats.connect("no_health", self, "queue_free")

	animation_tree.active = true
	sword_hit_box.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# Player is moving
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hit_box.knockback_vector = roll_vector
		
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	# Player is not moving
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL


func move():
	velocity = move_and_slide(velocity)
	

func attack_state():
	animation_state.travel("Attack")
	
	
func back_to_move_state():
	velocity = velocity / 2
	state = MOVE
	
	
func roll_state():
	animation_state.travel("Roll")
	
	velocity = (roll_vector * ROLL_SPEED) * 0.75
	move()


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	
	var hurt_sound = player_hurt_sound.instance()
	get_tree().current_scene.add_child(hurt_sound)


func _on_Hurtbox_invincibility_started():
	blink_animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
