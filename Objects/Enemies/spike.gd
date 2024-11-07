extends Area2D

var player
signal player_hit

func _ready():
	player = get_node("/root/Node2D/player")

func _on_body_entered(body):
	if body == player:
		emit_signal("player_hit")
