extends Node2D


@onready var gameInfo = $"Game Scene/Background/MarginContainer/Columns/rows/gameInfo"
@onready var command_Processor = $CommandProcessor
@onready var room_manager = $"Room Manager"
@onready var player = $Player

func _ready() -> void:
	gameInfo.handleResponse("Welcome to the text adventure, you can type 'help' to see available commands")
	var startingResponse = command_Processor.initialize(room_manager.get_child(0), player)
	gameInfo.handleResponse(startingResponse)

#when enter is pressed
func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var response = command_Processor.processCommand(new_text)
	gameInfo.handleResponseWithInput(response, new_text)
	
	







