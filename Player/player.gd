extends CharacterBody2D

# Exported variables for easy tweaking in the editor
@export var speed = 500
@export var gravity = 28
@export var jump_force = 700  # Adding jump force for jumping

# Other variables
var screen_size: Vector2

# Called when the node enters the scene tree for the first time
func _ready():
	screen_size = get_viewport_rect().size

# Called every physics frame (handles movement and collisions)
func _physics_process(delta):
	# Reset horizontal velocity each frame
	self.velocity.x = 0

	# Handle horizontal movement and animations
	if Input.is_action_pressed("right"):
		self.velocity.x += speed
		$AnimatedSprite2D.animation = "right"
	elif Input.is_action_pressed("left"):
		self.velocity.x -= speed
		$AnimatedSprite2D.animation = "left"

	# Apply gravity if not on the floor
	if not is_on_floor():
		self.velocity.y += gravity
	else:
		self.velocity.y = 0  # Reset vertical velocity when on the ground

	# Vertical movement (for "down" action, can be removed if not needed)
	if Input.is_action_pressed("down"):
		self.velocity.y += 10
		$AnimatedSprite2D.animation = "down"

	# Jump logic (pressing "up" makes the character jump)
	if Input.is_action_just_pressed("up") and is_on_floor():
		self.velocity.y = -jump_force  # Apply negative force to jump
		$AnimatedSprite2D.animation = "up"
	
	if is_on_wall():
		if velocity.x > 0:
			print("right wall")
		elif velocity.x < 0:
			print ("left wall")
		self.velocity.y = 0
	
	if is_on_wall() and Input.is_action_just_pressed("up"):
		var wall_direction = 0
		if velocity.x > 0:
			print("right wall")
			wall_direction = -1
		elif velocity.x < 0:
			print ("left wall")
			wall_direction = 1
		self.velocity.y = -jump_force/2
		self.velocity.x = speed * wall_direction
		
	# Use move_and_slide to handle movement and collision automatically
	move_and_slide()

	# Optional: Clamp the position to keep the player within the screen bounds
	position = position.clamp(Vector2.ZERO, screen_size)
