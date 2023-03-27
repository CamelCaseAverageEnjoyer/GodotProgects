extends KinematicBody2D

func _ready():
	$AnimatedSprite.set_flip_h(round(randi() % 2))
	$AnimatedSprite.set_speed_scale(3)

#func _physics_process(delta):
#	$AnimatedSprite.play("default")
