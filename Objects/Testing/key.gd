extends Sprite2D
@export var symbol: String
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play(symbol)
	$AnimatedSprite2D/AnimationPlayer.play("hover")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
