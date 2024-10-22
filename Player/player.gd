extends Area2D

@export var speed = 500
var screen_size
var y_motion = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	set_gravity(15)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("right"):
		velocity.x += 1
		$AnimatedSprite2D.animation = "right"
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		$AnimatedSprite2D.animation = "left"
		
		
		
	if y_motion > -350:
		y_motion -= gravity
		

	if Input.is_action_pressed("down"):
		
		y_motion -= 10
		$AnimatedSprite2D.animation = "down"
		print(y_motion)
		
		#We'll make this a jump button for now but I do want to change it to space bar or something
	if Input.is_action_pressed("up"):
		if y_motion < 500:
			y_motion += 250
		$AnimatedSprite2D.animation = "up"
		print(y_motion)
	
	if velocity.length() > 0:
		velocity = velocity * speed
	else:
		$AnimatedSprite2D.animation = "default"
	
	velocity.y -= y_motion
	
	position += velocity * delta 
	position = position.clamp(Vector2.ZERO, screen_size)
