extends MarginContainer

@onready var inputLabel = $Rows/inputHistory
@onready var responseLabel = $Rows/outputResponse

func set_text(response: String, input: String =""):
	if input == "":
		inputLabel.queue_free()
	else:
		inputLabel.text = " > " + input
	responseLabel.text = response
