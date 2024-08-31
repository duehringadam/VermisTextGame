extends LineEdit

var previous_input: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()

func _on_text_submitted(_new_text: String) -> void:
	previous_input = _new_text
	clear()

func _on_focus_exited() -> void:
	grab_focus()

