extends Button

signal close_settings

func _on_focus_entered() -> void:
	AudioManager.play_sound(load("res://sounds/SFX/click.wav"))
	emit_signal("close_settings")
