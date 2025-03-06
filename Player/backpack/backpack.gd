extends Sprite2D
@export var symbol: String
var win_condition = false
var player
var velocity: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO
var target: Vector2 = Vector2.ZERO
var right = 1

signal win()

# Called when the node enters the scene tree for the first time.
func _ready():
	 # Limit velocity to a reasonable range
	$AnimatedSprite2D.play("default")
	if symbol == "win_condition":
		$AnimatedSprite2D/AnimationPlayer.play("hover")
		win_condition = true
	else:
		$AnimatedSprite2D/AnimationPlayer.play("RESET")
		win_condition = false
		player = get_node("/root/Node2D/player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if win_condition == false and player:
		if player.right_left == 2:
			$AnimatedSprite2D.flip_h = false
			right = -15
		elif player.right_left == 1:
			$AnimatedSprite2D.flip_h = true
			right = 15
		velocity.x = clamp(velocity.x, -100, 100) 
		velocity = (global_position - previous_position) / delta
		previous_position = global_position
		target.x = player.global_position.x + right
		target.y = player.global_position.y
		global_position = global_position.lerp(target, .25)

func _on_area_2d_body_entered(body):
	if body.name == "player" and win_condition == true:
		get_tree().change_scene_to_file("res://Rooms/Room_Hub.tscn")
		PlayerData.jump_pack = true
		emit_signal("win")
