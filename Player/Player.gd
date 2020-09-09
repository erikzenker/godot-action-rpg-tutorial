extends KinematicBody2D
	
export(int) var acceleration = 600
export(int) var max_speed = 100
export(int) var roll_speed = max_speed * 1.2
export(int) var friction = 600

enum {
	Move,
	Roll,
	Attack
}

var state = Move
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/Hitbox
	
func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	
func _process(delta):
	match state:
		Move:
			move_state(delta)
			
		Roll:
			roll_state(delta)
			
		Attack:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = Roll
	
	if Input.is_action_just_pressed("attack"):
		state = Attack

func roll_state(delta):
	velocity = roll_vector * roll_speed
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_animation_finished():
	state = Move

func attack_animation_finished():
	state = Move
