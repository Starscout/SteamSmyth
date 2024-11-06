extends Node

var save_path = "user://save_data.json"



#Abilities in game
var abilities = {
	"double_jump": false,
	"grappling_hook": false,
	"steam_bomb": false,
	"magnet_gloves": false
}
func unlock_ability(ability_name: String):
	if abilities.has(ability_name):
		abilities[ability_name] = true
		

func has_ability(ability_name: String) -> bool:
	return abilities.get(ability_name, false)

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	if file:
		var json_data = JSON.stringify(abilities)
		file.store_string(json_data)
		file.close()
		print ("game saved")
	else:
		print("Failed to save")
		
		
		
func load_game():
	if FileAccess.file_exists(save_path):
		var load_file = FileAccess.open(save_path, FileAccess.READ)
		if load_file:
			var json_data = load_file.get_as_text()
			var json = JSON.new()
			var result = json.parse(json_data)
			if result.error == OK:
				abilities = result.result
				print ("Game loaded successfully")
			else:
				print("Failed to parse JSON data")
					
		else:
			print("Failed to load game")
	else:
		print("Save file not found")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
