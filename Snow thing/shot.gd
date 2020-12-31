extends Node2D

const SPEED = 600
var motion = Vector2()
var direction = 1

func _ready():
	pass # Replace with function body.

func _set_box_direction(direct):
	direction = direct
	if direct == -1:
		$Area2D/Sprite.flip_h = true

func _physics_process(delta):
	motion.x = SPEED * delta * direction
	translate(motion)
	


func _on_Area2D_body_entered(body):
	queue_free()





func _on_Timer_timeout():
	queue_free()
