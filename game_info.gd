extends PanelContainer

signal dialogue_ended_pass
signal player_status


const INPUTRESPONSE = preload("res://input/input_response.tscn")

var index: int
var queue = []
var queue_size = 1
const TITLE = preload("res://title_screen.tscn")
@onready var player =  $"../../../../../../../Player"
@onready var history_rows = $MarginContainer/ScrollContainer/historyRows
@onready var scroll = $MarginContainer/ScrollContainer
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
	
	#check player status
	#emit_signal("player_status")

####Private funcs####
func _handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value

func _deleteHistory():
	if history_rows.get_child_count() > max_lines_remembered:
		var rows_to_forget = history_rows.get_child_count() - max_lines_remembered
		for _i in range(rows_to_forget):
			history_rows.get_child(_i).queue_free()

func _addResponseToGame(response: Control):
	_deleteHistory()
	history_rows.add_child(response)

func _on_intro_text_dialogue_ended() -> void:
	emit_signal("dialogue_ended_pass")
	
func addTitle():
	var titlescreen = TITLE.instantiate()
	history_rows.add_child(titlescreen)
	index = titlescreen.get_index()
	
func removeTitle():
	for i in history_rows.get_child_count():
		history_rows.get_child((i - 1)).queue_free()
	
