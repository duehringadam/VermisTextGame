extends PanelContainer


const INPUTRESPONSE = preload("res://input/input_response.tscn")

@onready var history_rows = $ScrollContainer/historyRows
@onready var scroll = $ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()

@export var max_lines_remembered: int = 30

func _ready() ->void:
	scrollbar.connect("changed", _handle_scrollbar_changed)
	

####Public funcs####
func handleResponse(response_text: String):
	var response = INPUTRESPONSE.instantiate()
	_addResponseToGame(response)
	response.set_text(response_text)
	

func handleResponseWithInput(response_text: String, inputText: String):
	var inputResponse = INPUTRESPONSE.instantiate()
	#calls CommandProcessor script
	_addResponseToGame(inputResponse)
	inputResponse.set_text(response_text, inputText)
	

####Private funcs####
func _handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value

func _deleteHistory():
	if history_rows.get_child_count() > max_lines_remembered:
		var rows_to_forget = history_rows.get_child_count() - max_lines_remembered
		for _i in range(rows_to_forget):
			history_rows.get_child(_i).queue_free()

func _addResponseToGame(response: Control):
	history_rows.add_child(response)
	_deleteHistory()
	
func _addIntroToGame(intro: Node2D):
	history_rows.add_child(intro)
	_deleteHistory()
