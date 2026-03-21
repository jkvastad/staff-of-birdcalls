extends Control

@onready var button = $VBoxContainer/Button
@onready var audio_player = $AudioStreamPlayer2D

func _ready():
	button.pressed.connect(on_button_pressed)
	
func on_button_pressed():
	audio_player.stream = preload("res://Birdcalls/Finch/house-finch-song-1666.mp3")
	audio_player.play()
