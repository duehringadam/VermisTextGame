extends Node2D

@onready var gameInfo = $"Game Scene/Background/MarginContainer/Columns/rows/gameInfo"
@onready var command_Processor = $CommandProcessor
@onready var room_manager = $"Room Manager"
@onready var player = $Player
@onready var side_panel = $"Game Scene/Background/MarginContainer/Columns/sidePanel"
@onready var inputArea = $"Game Scene/Background/MarginContainer/Columns/rows/inputArea"



func _ready() -> void:
	pass

#when enter is pressed
func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var response = command_Processor.processCommand(new_text)
	gameInfo.handleResponseWithInput(response, new_text)
	
	

func _on_game_info_dialogue_ended_pass() -> void:
	$music.playing = true
	inputArea.visible = true
	command_Processor.room_changed.connect(side_panel.handle_room_changed)
	gameInfo.handleResponse("Welcome to VERMIS: MIST AND SHADOWS 
	you can type 'help' to see available commands")
	var startingResponse = command_Processor.initialize(room_manager.get_child(0), player)
	gameInfo.handleResponse(startingResponse)



func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_game_info_player_status() -> void:
	if player.health <=0:
		gameInfo.handleResponse("You have died! 
		You can quit by clicking the button on the bottom right of the screen.")
		inputArea.visible = false
	else:
		pass
