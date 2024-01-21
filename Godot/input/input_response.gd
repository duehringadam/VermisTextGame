extends VBoxContainer

func set_text(input: String,response: String):
	$inputHistory.text = " > " + input
	$outputResponse.text = response
