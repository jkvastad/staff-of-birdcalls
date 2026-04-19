extends Control

@onready var audio_player = $AudioStreamPlayer2D
@onready var scroll_container = $VBoxContainer/ScrollContainer
const bird_names = ["Finch","Raven","Duck","Chicken","Goose","Loon","Turkey","Gull","Owl","Eagle"]

@onready var bird_container = $VBoxContainer/ScrollContainer/BirdButtonContainer

func _ready():
	var icon_size = get_viewport_rect().size	
	audio_player.finished.connect(on_audio_finished)
	for bird_name in bird_names:
		var bird_button = TextureButton.new()
		bird_button.name = bird_name
		# allow mouse input to pass through buttons, enabling touch scroll
		bird_button.mouse_filter = Control.MOUSE_FILTER_PASS
		bird_button.stretch_mode = TextureButton.STRETCH_SCALE
		bird_button.custom_minimum_size = Vector2(icon_size.x/2,icon_size.y/5)
		bird_button.ignore_texture_size = true
		bird_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		bird_button.texture_normal = load("res://Birdcalls/" + bird_name + "/icon.webp")
		bird_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED
		bird_button.pressed.connect(on_button_pressed.bind(bird_name))
		bird_container.add_child(bird_button)
		
func on_audio_finished():	
	var eagle_button = bird_container.get_node("Eagle")
	if eagle_button:
		eagle_button.texture_normal = load("res://Birdcalls/" + "Eagle" + "/icon.webp")
	
func on_button_pressed(bird_name: String):
	# The "Eagle shriek" is actually a red tailed hawk - on click do a switchero!
	if audio_player.playing:
		audio_player.stop()
		on_audio_finished()
	if bird_name == "Eagle":
		var eagle_button = bird_container.get_node(bird_name)
		
		# Create false copy of eagle button which gets yeted out of the screen
		var eagle_texture = TextureRect.new()		
		eagle_texture.ignore_texture_size = true
		eagle_texture.texture = eagle_button.texture_normal
		
		eagle_texture.position = eagle_button.position
		print(eagle_button.size)		
		eagle_texture.size = eagle_button.size
		add_child(eagle_texture)
		
		#tween copy
		#TODO: accelerate image, looks too sudden 
		var yeet_duration = 3 #red tail hawk sound file length is 3.4
		
		var tween_position = get_tree().create_tween()
		tween_position.tween_property(
			eagle_texture,
			"position",									
			Vector2(-eagle_texture.position.x,-eagle_texture.position.y),
			yeet_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween_position.tween_callback(eagle_texture.queue_free)
		
		var tween_rotation = get_tree().create_tween()			
		var spin_speed = 5
		tween_rotation.tween_property(
			eagle_texture,
			"rotation",
			TAU*spin_speed*yeet_duration,
			yeet_duration
		).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).as_relative()														
		
		# Swap original button texture to hawk
		bird_name = "RedTailedHawk"				
		eagle_button.texture_normal = load("res://Birdcalls/" + bird_name + "/icon.webp")
		
	audio_player.stream = load("res://Birdcalls/" + bird_name + "/sound.mp3")
	audio_player.play()
