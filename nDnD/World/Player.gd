extends KinematicBody2D

var ACCELERATION = 5000
var MAX_SPEED = 5000
var stamina = 100
const DRAG = 0.2
onready var tilemap = $TileMap
var character = "Warrior"

export var flag_attack = false
export var motion = Vector2.ZERO

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	if y_input != 0:
		motion.y += y_input * ACCELERATION * delta
		motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	motion.x -= motion.x * DRAG
	motion.y -= motion.y * DRAG
	
	
	if motion.x < 0:
		$Going.set_flip_h(1)
		$HitBox/CollisionShape2D.position = Vector2(-104, 36)
	elif motion.x > 0:
		$HitBox/CollisionShape2D.position = Vector2(104, 36)
		$Going.set_flip_h(0)
	$Going.set_speed_scale(2)
	
	if Input.is_key_pressed(16777238):  # Ctrl
		$Going.set_speed_scale(5)
		ACCELERATION = 10000
		MAX_SPEED = 10000
	else:
		$Going.set_speed_scale(2)
		ACCELERATION = 5000
		MAX_SPEED = 5000
	
	$HitBox/CollisionShape2D.scale = Vector2(1, 1)
	flag_attack = false
	if character == "Warrior":
		if Input.is_key_pressed(67):  # 'C'
			flag_attack = true
			$Going.play("warrior_attack_1")
		elif Input.is_key_pressed(86): # 'V
			flag_attack = true
			$Going.play("warrior_attack_2")
			$HitBox/CollisionShape2D.scale = Vector2(3, 2)
		elif abs(motion.x) + abs(motion.y) > 5:
			$Going.play("warrior_run")
		else:
			$Going.play("warrior_wait")
	elif character == "Wizard":
		if Input.is_key_pressed(67) or Input.is_key_pressed(86):  # 'C' 'v
			flag_attack = true
			$Going.play("wizard_attack")
			$HitBox/CollisionShape2D.scale = Vector2(3, 2)
		elif (abs(motion.x) + abs(motion.y)) > 5:
			$Going.play("wizard_run")
		else:
			$Going.play("wizard_wait")
	else:
		if abs(motion.x) + abs(motion.y) > 5:
			$Going.play("pensil_run")
		else:
			$Going.play("pensil_wait")
			
	$HitBox/CollisionShape2D.disabled = not flag_attack
			
		
	
	
	# $Camera2D.set_custom_viewport()
	
	motion = move_and_slide(motion, Vector2.UP)
