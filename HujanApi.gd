extends Area2D

const SPEED = 100
var velocity = Vector2()
var direction = 1

func _ready():
	pass

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("Api")

func set_peler_direction(dir):
	direction = dir
	if dir == -1 :
		$AnimatedSprite.flip_h=false


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_HujanApi_body_entered(body):
	if "Player" in body.name :
		body.dead()
	queue_free()
