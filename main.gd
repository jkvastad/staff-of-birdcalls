extends Control

@onready var audio_player = $AudioStreamPlayer2D
@onready var scroll_container = $VBoxContainer/ScrollContainer
const bird_names = ["Finch","Raven","Duck","Chicken","Goose","Loon","Turkey","Gull","Owl","Eagle"]

@onready var bird_container = $VBoxContainer/ScrollContainer/BirdButtonContainer

func _ready():
	var icon_size = get_viewport().get_visible_rect().size	
	for bird_name in bird_names:
		var bird_button = TextureButton.new()
		# allow mouse input to pass through buttons, enabling touch scroll
		bird_button.mouse_filter = Control.MOUSE_FILTER_PASS
		bird_button.stretch_mode = TextureButton.STRETCH_SCALE
		bird_button.custom_minimum_size = Vector2(icon_size.x/2,icon_size.x/2)
		bird_button.ignore_texture_size = true
		bird_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		bird_button.texture_normal = load("res://Birdcalls/" + bird_name + "/icon.webp")
		bird_button.pressed.connect(on_button_pressed.bind(bird_name))
		bird_container.add_child(bird_button)
	
func on_button_pressed(bird_name: String):
	audio_player.stream = load("res://Birdcalls/" + bird_name + "/sound.mp3")
	audio_player.play()
