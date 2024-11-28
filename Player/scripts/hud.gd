extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$SaveIcon.modulate.a = 0
	for save_point in get_tree().get_nodes_in_group("SavePoints"):
		save_point.connect("save_point_activated", Callable(self, "_on_save_point_activated"))
	$"Fade In Out".visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_save_point_activated(_ignore):
	$SaveIcon/AnimationPlayer.play("fade_in")
	$SaveIcon.animation = "save_game"

func transition():
	$"Fade In Out".visible = true
	$"Fade In Out/Fades".play("fade_to_black")

func _on_fades_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		$"Fade In Out/Fades".play("fade_to_scene")
	elif anim_name == "fade_to_scene":
		$"Fade In Out".visible = false
