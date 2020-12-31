extends KinematicBody2D

const UP = Vector2(0, -1)
const ACCEL = 50
const DASH_SPEED = 950

var Max_speed = 450

var JumpHeight = 350
var JumpCount = 2
var Direction = 1
var Gravity = 20
var Button_timer = 1
var Can_dash = true
var JumpTaken = false

var motion = Vector2()

func _physics_process(delta):
	if JumpTaken == true:
		JumpCount + 1
	
	if not Input.is_action_pressed("Input_dash"):
		Button_timer = 0
	
	#Gravtiy
	motion.y += Gravity
	
	if Input.is_action_pressed("Input_dash"):
		Button_timer += delta
	
	if Input.is_action_pressed("Input_dash"):
		if Can_dash == true:
			$AnimatedSprite.play("dash")
			dash()
	elif Input.is_action_pressed("Input_right"):
		motion.x = min(motion.x+ACCEL, Max_speed)
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
		Direction = 1
	elif Input.is_action_pressed("Input_left"):
		motion.x = max(motion.x-ACCEL, -Max_speed)
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
		Direction = -1
	else:
		motion.x = 0
		$AnimatedSprite.play("default")
	
	#Resets jumps
	if is_on_floor():
		JumpCount = 3
		JumpTaken = false
	#allow jumps and takes jumps away
	if JumpCount > 0:
		if Input.is_action_just_pressed("Input_space"):
			motion.y = -JumpHeight
			JumpCount -= 1
	if not is_on_floor():
		JumpTaken = true
	
	motion = move_and_slide(motion, UP)
	#Set wall climb
	if is_on_wall():
		if Input.is_action_pressed("Input_up"):
			motion.y = -300
		if Input.is_action_pressed("Input_down"):
			motion.y = 200
	#Set wall stick
		if Input.is_action_pressed("Input_right") == true && Input.is_action_pressed("Input_up") == false && Input.is_action_pressed("Input_down") == false:
			motion.y = 0
		if Input.is_action_pressed("Input_left") == true && Input.is_action_pressed("Input_up") == false && Input.is_action_pressed("Input_down") == false:
			motion.y = 0
	#Set walljump
		if Input.is_action_just_pressed("Input_space"):
			motion.x = Direction * -300
			motion.y = -550
	
	if Input.is_action_pressed("Input_dash"):
		if Button_timer > $"Dash Timer".wait_time:
			Can_dash = false
			if Input.is_action_pressed("Input_right"):
				motion.x = min(motion.x+ACCEL, Max_speed)
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("run")
				Direction = 1
			elif Input.is_action_pressed("Input_left"):
				motion.x = max(motion.x-ACCEL, -Max_speed)
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("run")
				Direction = -1
			else:
				motion.x = 0
				$AnimatedSprite.play("default")
	
	print(JumpTaken, JumpCount)
	
	motion = move_and_slide(motion, UP)

func dash():
	Can_dash = false
	motion.x += Direction*DASH_SPEED
	$"Dash Timer".start() #dash timer

func _on_Timer_timeout(): #Dash timer
	$"Delay timer".start()


func _on_Delay_timer_timeout():
	Can_dash = true
