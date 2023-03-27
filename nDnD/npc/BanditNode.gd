extends Node2D

onready var animation_player := $Bandit/AnimatedSprite
export var action = "Waiting"
export var t_hurt = 1.0

func _physics_process(delta):
	if t_hurt < 0:
		action = "Waiting"
	if action == "Waiting":
		animation_player.play("default")
	else:
		t_hurt -= delta
		animation_player.play("hurt")

func take_damage(amount: int) -> void:
	t_hurt = 1.0
	action = "Heart"
	# animation_player.play("heart")
	print("Damage: ", amount)
