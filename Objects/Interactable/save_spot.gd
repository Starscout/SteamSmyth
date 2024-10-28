extends Area2D
var location = global_position
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/player")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body == player:
		pass 
