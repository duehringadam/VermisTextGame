extends Label

signal dialogue_ended

var messages = [$".".text]

var typing_speed = 0.01
var read_time = 10

var current_message = 0
var display = ""
var current_char = 0

func _ready():
	start_dialogue()
	
func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func stop_dialogue():
	emit_signal("dialogue_ended")
	queue_free()
	

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		
		$".".text = display
		current_char += 1
	else:
		$next_char.stop()
		$next_message.one_shot = true
		$next_message.set_wait_time(read_time)
		$next_message.start()

func _on_next_message_timeout():
	if (current_message == len(messages) - 1):
		stop_dialogue()
	else:
		read_time = 5
		if current_message == 0:
			current_message += 1
			display = "\n" + "\n" + "\n" + "\n"
		else:
			display += "\n" + "\n"
			current_message += 1
			read_time = 5
		current_char = 0
		$next_char.start()


func _on_next_message_ready() -> void:
	pass
