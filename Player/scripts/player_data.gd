extends Node

var save_path = "user://save_data.json"



#Abilities in game
var abilities = {
	"double_jump": false,
	"grappling_hook": false,
	"steam_bomb": false,
	"magnet_gloves": false
}

var new_game = false

func unlock_ability(ability_name: String):
	if abilities.has(ability_name):
		abilities[ability_name] = true
		

func has_ability(ability_name: String) -> bool:
	return abilities.get(ability_name, false)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
