extends KinematicBody2D

const SPEED = 125
const GRAVITY = 10
const JUMP_POWER = -275
const FLOOR = Vector2(0,-1) 
const SLASH = preload("res://slash.tscn")
 
export(int) var hp = 5

var velocity = Vector2()

var on_ground = false

var is_attacking = false

var is_dead = false

func _ready():
	set_process(true)

func _process(delta):
		#Clicking Part
	if Input.is_action_just_pressed("ui_focus_next") and is_on_floor():
		var musicNode = $"Audio Effect/AudioStreamPlayer2D"
		musicNode.play()
		
		#Release Part
	elif Input.is_action_just_released("ui_focus_next"):
		var musicNode = $"Audio Effect/AudioStreamPlayer2D"
		musicNode.stop()

# warning-ignore:unused_argument
func _physics_process(delta):

	if is_dead == false :
	
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false || is_on_floor() == false:
				velocity.x = SPEED
				if is_attacking == false :
					$AnimatedSprite.play("jalan")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1 :
						$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false || is_on_floor() == false :
				velocity.x = -SPEED
				if is_attacking == false :
					$AnimatedSprite.play("jalan")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1 :
						$Position2D.position.x *= -1
		else :
			velocity.x = 0
			if on_ground == true && is_attacking == false:
				$AnimatedSprite.play("diam")
		if Input.is_action_pressed("ui_up"):
			if is_attacking == false :
				if on_ground == true :
					velocity.y = JUMP_POWER
					on_ground = false
		
		if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
			if is_on_floor() :
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("serang")
			var slash = SLASH.instance()
			if sign($Position2D.position.x) == 1:
				slash.set_slash_direction(1)
			else :
				slash.set_slash_direction(-1)
			get_parent().add_child(slash) 
			slash.position = $Position2D.global_position
			
		velocity.y += GRAVITY
		
		if is_on_floor() :
			if on_ground == false :
				is_attacking = false
			on_ground = true
		else :
			if is_attacking == false :
				on_ground = false
				if velocity.y < 0 :
					$AnimatedSprite.play("lompat")
				else : 
					$AnimatedSprite.play("jatuh")
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0 :
			for i in range (get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()

func dead(): 
	hp = hp - 1
	$AnimatedSprite.play("kenahit")
	if hp <= 0 :
		is_dead = true
		velocity = Vector2(0,0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		$Timer.start()

func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Timer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("StageOne.tscn")


func _on_Area2D_area_entered(area):
	if area.is_in_group("Kapak"):
		dead()
