extends CharacterBody2D


const SPEED = 150
var current_dir = "none"

#on spawn plays front idle animation
func _ready():
	$AnimatedSprite2D.play("front_idle")

#calls player movement
func _physics_process(delta: float) -> void:
	player_movement(delta)

#player movement
func player_movement(delta):
#checks if input pressed is right, left, up, down and sets vertical and horizontal speed accordingly
#also sets direction and calls animation func
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	move_and_slide()

#func plays animations
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	#if dir variable is equal to direction pressed it plays certain animations
	match dir:
		"right":
			anim.flip_h = false
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		"left":
			anim.flip_h = true
			if movement == 1:
				anim.play("side_walk")
			elif movement == 0:
				anim.play("side_idle")
		"up":
			anim.flip_h = false
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				anim.play("back_idle")
		"down":
			anim.flip_h = false
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				anim.play("front_idle")
		
