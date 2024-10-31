extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$SaveIcon.modulate.a = 0
	for save_point in get_tree().get_nodes_in_group("SavePoints"):
		save_point.connect("save_point_activated", Callable(self, "_on_save_point_activated"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_save_point_activated(_ignore):
	$SaveIcon/AnimationPlayer.play("fade_in")
	$SaveIcon.animation = "save_game"
