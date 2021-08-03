extends KinematicBody2D

var player = null
var is_dead = false
const api = preload("res://HujanApi.tscn")
var velocity = Vector2()
const GRAVITY = 10
const FLOOR = Vector2(0, -1)

export(int) var hp = 1

func _on_Area2D_body_entered(body):
	if body != player :
		player = body

func _on_Area2D_body_exited(body):
	player = null
	$AnimatedSprite.play("diam")

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


func _on_Timer2_timeout():
	if is_dead == false :
		if player != null:
			$AnimatedSprite.play("serang")
			var peler = api.instance()
			peler.set_peler_direction(1)
			get_parent().add_child(peler)
			peler.position = $Position2D.global_position



func _on_Timer3_timeout():
	if is_dead == false :
		if player != null:
			$AnimatedSprite.play("serang")
			var peler = api.instance()
			peler.set_peler_direction(-1)
			get_parent().add_child(peler)
			peler.position = $Position2D2.global_position 
