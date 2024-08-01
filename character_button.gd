extends Button


@export var button_class: Resource
@onready var button = $"."
var signalcount = 0

func _ready():
	set_focus_mode(FOCUS_ALL)
	#grab_focus()
	var buttonIcon = load("res://Classes/" + str(button_class.player_stats["Name"]) + ".tres")
	button.icon = buttonIcon.icon
	

func _on_pressed() -> void:
	pass
	



func _on_focus_entered() -> void:
	AudioManager.play_sound(load("res://sounds/SFX/click.wav"))
	CharacterSelectManager.set_select_bool(true)
	CharacterSelectManager.emit_signal("character_selected", button_class)
	
	
