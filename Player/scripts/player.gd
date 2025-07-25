extends CharacterBody2D
# Exported variables for easy tweaking in the editor
@export var speed = 500
@export var gravity = 32
@export var jump_force = 700  # Adding jump force for jumping
@export var jump_buffer_time = .1
@export var coyote_time = .1
@export var wall_jump_cooldown = 0.2
# Other variables
var jump_buffer_timer = 0.0
var coyote_timer = 0.0
var wall_jump_timer = 0.0
var wall_jump_left = 0
var screen_size: Vector2
var is_near_left_wall = false
var is_near_right_wall = false
var about_to_hit_left_wall = false
var about_to_hit_right_wall = false
var wall_jumped = false
var dashed = false
var dashing = false
var speed_up = 3
var speed_down = 8
var speed_change = 0
var right_left = 0
var respawn_location = position
var dash_timer = 6
var dash_change = 0
var dead = false
signal player_path_sent(path: NodePath)
var hud
var backpack = preload("res://Player/backpack/Backpack.tscn")

# Called when the node enters the scene tree for the first time
func _ready():
	
	screen_size = get_viewport_rect().size
	#send a signal to camera of my path
	emit_signal("player_path_sent", get_path())

	for save_point in get_tree().get_nodes_in_group("SavePoints"):
		save_point.connect("save_point_activated", Callable(self, "_on_save_point_activated"))
	var spikes = get_tree().get_nodes_in_group(("spikes"))
	for spike in spikes:
		spike.connect("player_hit", Callable(self, "_on_player_hit"))
	hud = get_tree().get_root().get_node("/root/Node2D/HUD")

		
func _physics_process(delta):
	# Reset horizontal velocity each frame
	if dashing == false:
		self.velocity.x = 0
		$DashParticles.emitting = false
	# Handle horizontal movement and animations
	if wall_jump_timer > 0:
		wall_jump_timer -= delta
		if Input.is_action_pressed("left"):
			self.velocity.x += speed * wall_jump_left -50
		else:
			self.velocity.x += speed * wall_jump_left
		self.velocity.y = -jump_force/2
	elif dead == false:
		#Start speed-up
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
			speed_change = speed_up
			# Slow down for your first 3 frames then go (OR not released
		elif (Input.is_action_pressed("right") and speed_change > 0):
			self.velocity.x += speed/3
			speed_change -= 1
			$AnimatedSprite2D.play("right")
		elif Input.is_action_pressed("left") and speed_change > 0:
			self.velocity.x -= speed/3
			speed_change -= 1
			$AnimatedSprite2D.animation = "right"
			
		elif Input.is_action_pressed("right") and dashing == false:
			self.velocity.x += speed
			$AnimatedSprite2D.animation = "right"
		elif Input.is_action_pressed("left") and dashing == false:
			self.velocity.x -= speed
			$AnimatedSprite2D.animation = "right"
		#Slow down for 6 frames after release
		elif Input.is_action_just_released("left") and is_on_floor():
			speed_change = speed_down
			right_left = 1
		elif Input.is_action_just_released("right") and is_on_floor():
			speed_change = speed_down
			right_left = 2
		elif speed_change > 0 and right_left == 1:
			self.velocity.x -= speed/3
			speed_change -= 1
		
		elif speed_change > 0 and right_left == 2:
			self.velocity.x += speed/3
			speed_change -= 1
			
		elif self.velocity.y == 0:
				$AnimatedSprite2D.play("idle")
	if speed_change == 0:
		right_left = 0
	if self.velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		right_left = 2
		$DashParticles.scale.x = 1
	elif self.velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		right_left = 1
		$DashParticles.scale.x = -1
	# Apply gravity if not on the floor
	if not is_on_floor() and not dead:
		if is_on_wall() and self.velocity.y > 0:
			self.velocity.y += gravity/2
			$AnimatedSprite2D.play("sidewall")
		else:
			self.velocity.y += gravity
	
	else:
		if !dashing:
			self.velocity.y = 0  # Reset vertical velocity when on the ground
	# Vertical movement (for "down" action, can be removed if not needed)
	if Input.is_action_pressed("down"):
		self.velocity.y += 10
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		
	if (is_on_floor() and Input.is_action_just_pressed("jump")):
		self.velocity.y = -jump_force
		jump_buffer_timer = 0
		$AnimatedSprite2D.play("up")
		
#Wall Jump stuffs
	#Wall only stuff
	about_to_hit_left_wall = $Raycast_left.is_colliding()
	about_to_hit_right_wall = $Raycast_right.is_colliding()
	#Coyote
	if (is_on_floor()):
		coyote_timer = coyote_time
		dashed = false
	if (not is_on_wall() and coyote_timer > 0 and Input.is_action_just_pressed("jump")):
		self.velocity.y = -jump_force
	if is_on_wall():
		$AnimatedSprite2D.play("sidewall")
	if coyote_timer > 0:
		coyote_timer -= delta
	#Jump Buffer
		#Wall Jump Left Call
	if (jump_buffer_timer > 0 and (about_to_hit_left_wall) and coyote_timer < 0 and not dead):
		jump_buffer_timer = 0
		wall_jump_timer = wall_jump_cooldown
		wall_jump_left = 1
		$AnimatedSprite2D.play("up")
		#Wall Jump Right Call
	if (jump_buffer_timer > 0 and about_to_hit_right_wall and coyote_timer < 0 and not dead):
		jump_buffer_timer = 0
		wall_jump_timer = wall_jump_cooldown
		wall_jump_left = -1
		$AnimatedSprite2D.play("up")
	# Use move_and_slide to handle movement and collision automatically
	move_and_slide()
	
	#Death button and save location
	if Input.is_action_just_pressed("reset"):
		death()
		
	if Input.is_action_just_pressed("dash") and dashed == false and PlayerData.jump_pack == true:
		wall_jump_timer = 0
		
		dashing = true
		
		dash_change = dash_timer
		if Input.is_action_pressed("left") and Input.is_action_pressed("up"):
			self.velocity.x = -750
			self.velocity.y = -750
		elif Input.is_action_pressed("left") and Input.is_action_pressed("down"):
			self.velocity.x = -750
			self.velocity.y = 750
		elif Input.is_action_pressed("right") and Input.is_action_pressed("up"):
			self.velocity.x = 750
			self.velocity.y = -750
		elif Input.is_action_pressed("right") and Input.is_action_pressed("down"):
			self.velocity.x = 750
			self.velocity.y = 750
		elif Input.is_action_pressed("left"):
			self.velocity.x = -1200
			self.velocity.y = 0
		elif Input.is_action_pressed("right"):
			self.velocity.x = 1200
			self.velocity.y = 0
		elif Input.is_action_pressed("up"):
			self.velocity.y = -900
		elif Input.is_action_pressed("down"):
			self.velocity.y = 900
			
	if dash_change > 0:
		dash_change -= 1
		dashed = true
		$DashParticles.emitting = true
	else: 
		dashing = false
	if self.velocity.y < 0:
		$AnimatedSprite2D.play("up")

	if self.velocity.y > 0 and not is_on_wall():
		$AnimatedSprite2D.play("down")
	
	if PlayerData.jump_pack == true and not get_node("../Sprite2D"):
		add_sibling(backpack.instantiate())
	
func add_backpack():
	pass
	
func _on_save_point_activated(new_position):
	respawn_location = new_position
func _on_player_hit():
	death()

func death():
	PlayerData.death_counter += 1
	$DeathFlash.play("DeathFlash")
	hud.transition()
	$RespawnTimer.start()
	dead = true
	self.velocity.y = -self.velocity.y
	self.velocity.x = -self.velocity.x
	$AnimatedSprite2D.animation = "dead"
func _on_respawn_timer_timeout():
	global_position = respawn_location
	dead = false
