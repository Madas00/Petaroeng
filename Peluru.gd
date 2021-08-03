extends Area2D

const SPEED = 100
var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	velocity.x = SPEED * delta
	translate(velocity)
	$AnimatedSprite.play("tembak")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Peluru_body_entered(body):
	if "Player" in body.name :
		body.dead()
	queue_free()
