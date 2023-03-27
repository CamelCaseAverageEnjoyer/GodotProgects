extends KinematicBody2D

var ACCELERATION = 5000
var MAX_SPEED = 5000
var error = [0.1, 0.1]
var i_time = 0
const DRAG = 0.2
onready var tilemap = $TileMap
export var motion = Vector2.ZERO

var target = Vector2.ZERO
var flag_go_to_target = false
var attacking = false
var counter = 100

func _ready():
	$AnimatedSprite.set_speed_scale(2)

func _physics_process(delta):
	i_time += 1
	
	# Decision
	if not flag_go_to_target and not attacking:
		counter = 100
		flag_go_to_target = true
		attacking = false
		var file = File.new()
		file.open("res://storage/positions.txt", File.READ)
		var file_pos = file.get_as_text().split(' ')
		var choice = randi() % 5
		print(choice)
		target.x = float(file_pos[0 + choice * 2])
		target.y = float(file_pos[1 + choice * 2])
		file.close()
	
	if i_time % 50 == 0:
		error = [float(randi()%100/100), float(randi()%100/100)]
		
	var tmp_x = target.x - position.x
	var tmp_y = target.y - position.y
	
	var x_input = 0
	var y_input = 0
	if abs(tmp_x) < 20 and abs(tmp_y) < 20:
		if flag_go_to_target:
			attacking = true
			flag_go_to_target = false
		else:
			counter -= 1
			if counter < 0:
				attacking = false
				flag_go_to_target = false
	else:
		x_input =  fmod((tmp_x / sqrt(pow(tmp_x, 2) + pow(tmp_y, 2))), 1)
		y_input =  fmod((tmp_y / sqrt(pow(tmp_x, 2) + pow(tmp_y, 2))), 1)
		x_input = fmod(x_input + error[0], 1)
		y_input = fmod(y_input + error[1], 1)
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	if y_input != 0:
		motion.y += y_input * ACCELERATION * delta
		motion.y = clamp(motion.y, -MAX_SPEED, MAX_SPEED)
	motion.x -= motion.x * DRAG
	motion.y -= motion.y * DRAG
	
	if motion.x < 0:
		$AnimatedSprite.set_flip_h(1)
	elif motion.x > 0:
		$AnimatedSprite.set_flip_h(0)
	if abs(motion.x + motion.y) < 10:
		$AnimatedSprite.play("attack")
	else:
		$AnimatedSprite.play("run")
		
	$MyHitBox/CollisionShape2D.disabled = not attacking
	
	# $Camera2D.set_custom_viewport()
	
	motion = move_and_slide(motion, Vector2.UP)
