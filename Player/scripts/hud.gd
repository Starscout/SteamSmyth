extends CanvasLayer
var icon_timer = 0
var icon_time = 200
var icon_transparency = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$SaveIcon.modulate.a = icon_transparency
	for save_point in get_tree().get_nodes_in_group("SavePoints"):
		save_point.connect("save_point_activated", Callable(self, "_on_save_point_activated"))




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if icon_timer > 0:
		icon_timer -= 1
		icon_transparency += 1
		$SaveIcon.modulate.a = icon_transparency
		
	
func _on_save_point_activated(ignore):
	icon_timer = icon_time
