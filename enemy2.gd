extends KinematicBody2D

var velocity = Vector2()
const GRAVITY = 10 
const FLOOR = Vector2(0, -1)
var is_dead = false

export(int) var hp = 1

func _on_Area2D_body_entered(body):
	if body != self :
		$AnimatedSprite.play("pukul")
		$Hit/CollisionShape2D.disabled = false



func _on_Area2D_body_exited(body):
	$AnimatedSprite.play("diam")
	$Hit/CollisionShape2D.disabled = true

func _physics_process(delta):
	if is_dead == false :
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)

func dead() :
	hp -= 1
	if hp <= 0:
		is_dead = true
		velocity = Vector2(0, 0)
		$CollisionShape2D.disabled = true
		$Timer.start()




func _on_Timer_timeout():
	queue_free()
	

