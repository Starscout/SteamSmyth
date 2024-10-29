extends Node2D

# Signal to notify other parts of the game of a new save location
signal save_point_activated(position: Vector2)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate():
		emit_signal("save_location_set", global_position)


func _on_area_2d_body_entered(body):
	if body.name == "player":
		emit_signal("save_point_activated", global_position)
