extends Camera2D



var player
var is_following_player = false
var smooth_stop_timer = 0.0  # Timer for smooth stop transition
var smooth_stop_duration = 0.3  # Duration for smooth stopping (in seconds)


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/player")



func _process(delta):
	if is_following_player and player:
		global_position = lerp(global_position, player.global_position, 0.03)
	elif smooth_stop_timer > 0:
		var stop_lerp_factor = smooth_stop_timer / smooth_stop_duration * 0.03
		global_position = lerp(global_position, player.global_position, stop_lerp_factor)
		smooth_stop_timer -= delta


func _on_outer_area_body_exited(body):
	if body == player and not is_following_player:
		is_following_player = true


func _on_inner_area_body_entered(body):
	if body == player and is_following_player:
		is_following_player = false
		smooth_stop_timer = smooth_stop_duration
	
