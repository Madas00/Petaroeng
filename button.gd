extends Button

onready var sound = $AudioStreamPlayer2D




func _on_Start_pressed():
	sound.play()
