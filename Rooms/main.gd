extends Node2D

@export var save_location_display: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	for save_point in get_tree().get_nodes_in_group("save_point"):
		save_point.connect("save_point_activated", Callable(self, "_on_save_point_activated"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_save_point_activated(position: Vector2):
	save_location_display.update_position(position)
