extends Control

@onready var audio_player = $AudioStreamPlayer2D
var bird_names = ["Finch", "Raven"]

@onready var vbox_container = $VBoxContainer/BirdButtonContainer

func _ready():
	for bird in bird_names:
		var bird_button = TextureButton.new()
		bird_button.texture_normal = load("res://Birdcalls/" + bird + "/icon.webp")
		bird_button.pressed.connect(on_button_pressed.bind(bird))
		vbox_container.add_child(bird_button)
	
func on_button_pressed(bird_name: String):
	audio_player.stream = load("res://Birdcalls/" + bird_name + "/sound.mp3")
	audio_player.play()
