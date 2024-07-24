extends Node2D

#const PLAYER = preload("res://Player.gd")
@onready var room_music = $"room music"
@onready var introText = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo/MarginContainer/ScrollContainer/historyRows/intro_text"
@onready var gameInfo = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo"
@onready var historyrows = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo/MarginContainer/ScrollContainer/historyRows"
@onready var command_Processor = $CommandProcessor
@onready var room_manager = $"Room Manager"
@onready var player = $Player
@onready var side_panel = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/sidePanel"
@onready var inputArea = $"Game Scene/Background/MarginContainer/Columns/rows/inputArea"
@onready var playerInput = $"Game Scene/Background/MarginContainer/Columns/rows/inputArea/inputHbox/input"
@onready var visualArea = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea"
@onready var playerInfo = $"Game Scene/Background/MarginContainer/Columns/rows/columns/playerInfo"
@onready var areaPicture = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/areaPicture"
@onready var inventoryArea = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/playerInventory"
@onready var quitButton = $"Game Scene/Background/MarginContainer/Columns/rows/inputArea/inputHbox/quit_button"
@onready var visualContainer = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer"
@onready var characterSelect = $"Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/character select"

func _ready() -> void:
	command_Processor.room_changed.connect(room_music.change_music)
	
func _process(_delta) -> void:
	#skip intro sequence when pressing debug key "f9"
	if Input.is_action_just_pressed("debug") && is_instance_valid(introText):
		introText.queue_free()
		_on_game_info_dialogue_ended_pass()
	else:
		pass
	if player.player_dead == true:
		var max_lines_remembered = 0
		var rows_to_forget = historyrows.get_child_count() - max_lines_remembered
		for _i in range(rows_to_forget):
			historyrows.get_child(_i).queue_free()
		gameInfo.handleResponse("You have died!") 
		gameInfo.handleResponse("You can quit by clicking the button on the bottom of the screen.")
		player.player_dead = false
		playerInput.editable = false
	playerInfo.update_player(player)
	

#when enter is pressed
func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	var response = command_Processor.processCommand(new_text)
	gameInfo.handleResponseWithInput(response, new_text)
	
	if CharacterSelectManager.select_bool == true && new_text == "confirm":
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.wait_time = 3.0
	
		CharacterSelectManager.set_select_bool(false)
		timer.timeout.connect(start_game)
		
		timer.start()
		
	

func _on_game_info_dialogue_ended_pass() -> void:
	#$music.playing = true
	visualArea.visible = true
	inputArea.visible = true
	side_panel.visible = false
	quitButton.visible = true
	characterSelect.visible = true
	playerInfo.visible = false
	areaPicture.visible = false
	inventoryArea.visible = false
	
	
	CharacterSelectManager.character_selected.connect(characterSelectDescription)
	CharacterSelectManager.character_selected.connect(player.character_select)
	command_Processor.room_changed.connect(side_panel.handle_room_changed)
	
	
	gameInfo.handleResponse("Select your flesh, it will only be temporary, this decision only has the weight you give to it.")
	gameInfo.handleResponse("Type confirm to continue.")
	


func characterSelectDescription(character: Resource):
	gameInfo.handleResponse(character.player_stats["Name"])
	gameInfo.handleResponse(character.description)
	gameInfo.handleResponse("Strength: " + str(character.player_stats["Strength"]))
	gameInfo.handleResponse("Intelligence: " + str(character.player_stats["Intelligence"]))
	gameInfo.handleResponse("Faith: " + str(character.player_stats["Faith"]))
	gameInfo.handleResponse("Will: " + str(character.player_stats["Will"]))

func start_game():
	playerInfo.visible = true
	areaPicture.visible = true
	inventoryArea.visible = true
	#characterSelect.visible = false
	characterSelect.queue_free()
	side_panel.visible = true
	var startingResponse = command_Processor.initialize(room_manager.get_child(0), player)
	gameInfo.handleResponse(startingResponse)
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()

		
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
		#gameInfo.handleResponse(command_Processor.changeRoom(node_data["current_room"]))
		

func _on_command_processor_load_game() -> void:
	load_game()


