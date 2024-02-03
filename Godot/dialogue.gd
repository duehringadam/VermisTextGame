extends VBoxContainer


var messages = [
	"Starting MichaelSoft DOS...
	
	
	(C)Copyright Michaelsoft Corp 1981-1990.
	
	
	C:/>cd vrms
	C:/>vrms setup
	
	
	DETECTING...
	[Processor]: AMF 3-420 Processor.
	[Power]: ABM V1.2.
	[Op/Sytem]: MICHAELSOFT-DOS V8.22 [Standard].
	[32-bit mode]: 16-bit Interface.
	
	INSTALLING...
	
	VERMIS: MIST AND SHADOWS INSTALLED SUCCESSFULY.
	
	C:/>run vrms
	
	LAUNCHING VERMIS: MIST AND SHADOWS...",
	""
]

var typing_speed = 0.01
var read_time = 2

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
	pass
	

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		
		$Label.text = display
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
		current_message += 1
		display = ""
		current_char = 0
		$next_char.start()


func _on_next_message_ready() -> void:
	pass

