extends KinematicBody2D

onready var Player = get_parent().get_node("Player")

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -400
const FLOOR = Vector2(0,-1) 

var on_ground = false
var velocity = Vector2()

var react_time = 20
var dir = 0
var next_dir = 0
var next_dir_time = 0
var next_jump_time = -1

var target_player_dist = 30

var eye_reach = 90
var vision = 320

func set_dir(target_dir) :
	if next_dir != target_dir :
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time
		
func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center+Vector2(0,eye_reach)
	var eye_left = eye_center+Vector2(eye_reach,0)
	var eye_right = eye_center+Vector2(eye_reach,0)
	
	var player_pos = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1,1)
	var top_left = player_pos + Vector2(-player_extents.x , -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x , -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x , player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x , player_extents.y)
	
	var space_state = get_world_2d().direct_space_state
	
	for eye in [eye_center, eye_top, eye_left, eye_right]: 
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if (corner - eye).length() > vision :
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1)
			if collision and collision.collider.name == "Player" :
				return true
	return false  
	
func _physics_process(delta):
	
	print(sees_player())
	
	if Player.position.x < position.x - target_player_dist :
		set_dir(-1)
		$AnimatedSprite.play("lari")
		$AnimatedSprite.flip_h = true
	elif Player.position.x > position.x + target_player_dist :
		set_dir(1)
		$AnimatedSprite.play("lari")
		$AnimatedSprite.flip_h = false
	else : 
		set_dir(0)
		$AnimatedSprite.play("diam")
	
	if OS.get_ticks_msec() > next_dir_time :
		dir = next_dir
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor() :
		if Player.position.y < position.y - 64 :
			velocity.y = JUMP_POWER
		next_jump_time = -1
	
	velocity.x = dir * 30
	
	if Player.position.y < position.y - 64 and is_on_floor() and next_jump_time == -1 :
		next_jump_time = OS.get_ticks_msec() + react_time
		
		
	velocity.y += GRAVITY
	
  
	
	velocity = move_and_slide(velocity, FLOOR)
