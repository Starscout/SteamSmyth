extends AudioStreamPlayer


var Room1_music = preload("res://Audio/Music/Whispers in the Rust.mp3")

var music_player = null
var music_song = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_music(stream: AudioStream, loop: bool = true):
	if music_player.stream != Room1_music:
		music_player.stop()
		music_player.stream = Room1_music
		stream.loop = loop
	music_player.play

func stop_music():
	music_player.stop()
