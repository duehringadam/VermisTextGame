extends Node2D

const Response = preload("res://input/response.tscn")
const InputResponse = preload("res://input/input_response.tscn")

@export var max_lines_remembered: int = 30

@onready var command_Processor = $CommandProcessor
@onready var history_rows = $"Game Scene/Background/MarginContainer/rows/gameInfo/ScrollContainer/historyRows"
@onready var scroll = $"Game Scene/Background/MarginContainer/rows/gameInfo/ScrollContainer"
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var room_manager = $"Room Manager"


func _ready() -> void:
	handleResponse("Welcome to the text adventure, you can type 'help' to see available commands")
	scrollbar.connect("changed", handle_scrollbar_changed)
	#command_Processor.response_generated.connect(handleResponse)
	var startingResponse = command_Processor.initialize(room_manager.get_child(0))
	handleResponse(startingResponse)


func handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value

#when enter is pressed
func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
		
	#variables
	var inputResponse = InputResponse.instantiate()
	#calls CommandProcessor script
	var response = command_Processor.processCommand(new_text)
	inputResponse.set_text(new_text, response)
	addResponseToGame(inputResponse)
	

func handleResponse(response_text: String):
	var response = Response.instantiate()
	response.text = response_text
	addResponseToGame(response)

func addResponseToGame(response: Control):
	history_rows.add_child(response)
	deleteHistory()


func deleteHistory():
	if history_rows.get_child_count() > max_lines_remembered:
		var rows_to_forget = history_rows.get_child_count() - max_lines_remembered
		for _i in range(rows_to_forget):
			history_rows.get_child(_i).queue_free()
