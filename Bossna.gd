extends KinematicBody2D

var player = null
var tembak = preload("res://Peluru.tscn")
var is_dead = false
export(int) var hp = 10
var velocity = Vector2()
const GRAVITY = 10
const FLOOR = Vector2(0, -1)

func _physics_process(delta):
	if is_dead == false :
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		
func _on_Area2D_body_entered(body):
	if body != player :
		player = body

func _on_Area2D_body_exited(body):
	player = null
	$AnimatedSprite.play("duduk")


func _on_Timer_timeout():
	if is_dead == false :
		if player != null:
			$AnimatedSprite.play("serang")
			var peluru = tembak.instance()
			get_parent().add_child(peluru)
			peluru.position = $Position2D.global_position

func dead() :
	hp -= 1
	if hp <= 0 :
		is_dead = true
		$CollisionShape2D.disabled = true
		$Timer2.start()


func _on_Timer2_timeout():
	queue_free()
