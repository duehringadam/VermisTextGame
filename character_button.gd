extends Button


@export var button_class: Resource
@onready var button = $"."
var signalcount = 0

func _ready():
	var buttonIcon = load("res://Classes/" + str(button_class.player_stats["Name"]) + ".tres")
	button.icon = buttonIcon.icon
	button.focus_mode = 0

func _on_pressed() -> void:
	CharacterSelectManager.emit_signal("character_selected", button_class)
	CharacterSelectManager.set_select_bool(true)
	
