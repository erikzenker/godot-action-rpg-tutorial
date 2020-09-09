extends KinematicBody2D

const friction = 200
const speed = 140

var knockback = Vector2.ZERO

onready var stats = $Stats

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * speed

func _on_Stats_no_health():
	queue_free() 

