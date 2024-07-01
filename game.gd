extends Node2D

@onready var gameInfo = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo"
@onready var command_Processor = $CommandProcessor
@onready var room_manager = $"Room Manager"
@onready var player = $Player
@onready var side_panel = $"Game Scene/Background/MarginContainer/Columns/rows/columns/sidePanel"
@onready var inputArea = $"Game Scene/Background/MarginContainer/Columns/rows/inputArea"
@onready var visualArea = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea"
@onready var inventoryArea = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/playerInventory"
@onready var quitButton = $"Game Scene/Background/MarginContainer/Columns/rows/inputArea/inputHbox/quit_button"


func _ready() -> void:
	pass
	
func _process(_delta) -> void:
	#skip intro sequence when pressing debug key "f9"
	if Input.is_action_just_pressed("debug"):
		$"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo/ScrollContainer/historyRows/intro_text".queue_free()
		_on_game_info_dialogue_ended_pass()
	

#when enter is pressed
func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var response = command_Processor.processCommand(new_text)
	gameInfo.handleResponseWithInput(response, new_text)
	
	

func _on_game_info_dialogue_ended_pass() -> void:
	$music.playing = true
	inputArea.visible = true
	side_panel.visible = true
	visualArea.visible = true
	quitButton.visible = true
	
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
		
		
func save():
	var save_dict = {
		"player_hp": player.health,
		"inventory_held": player.inventoryHeld,
		"player_damage": player.damage,
		"inventory": player.inventory,
		"current_room": command_Processor.current_room
	}
	return save_dict

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func _on_command_processor_save_game() -> void:
	save_game()
	
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		print(node_data)
		
		player.inventory = node_data["inventory"]
		player.health = node_data["player_hp"]
		player.inventoryHeld = node_data["inventory_held"]
		player.damage = node_data["player_damage"]
		print(command_Processor.current_room)
		#gameInfo.handleResponse(command_Processor.changeRoom(current_room))
		


func _on_command_processor_load_game() -> void:
	load_game()
