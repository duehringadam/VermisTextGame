extends Node2D

const TITLE = preload("res://title_screen.tscn")
@onready var room_music = $"room music"
@onready var combat = $Combat
@onready var introText = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo/MarginContainer/ScrollContainer/historyRows/intro_text"
@onready var gameInfo = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo"
@onready var historyrows = $"Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo/MarginContainer/ScrollContainer/historyRows"
@onready var command_Processor = $CommandProcessor
#@onready var new_CommandProcessor = $"New Command Processor"
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
	#new_CommandProcessor.process_command("talk to aspect of the dream")
	command_Processor.room_changed.connect(room_music.change_music)
	CharacterSelectManager.character_selected.connect(characterSelectDescription)
	CharacterSelectManager.character_selected.connect(player.character_select)
	command_Processor.room_changed.connect(side_panel.handle_room_changed)

func _process(_delta) -> void:
	#skip intro sequence when pressing debug key "f9"
	if Input.is_action_just_pressed("debug") && is_instance_valid(introText):
		introText.queue_free()
		title_screen()
	
	if is_instance_valid(playerInfo):
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
		
	

func title_screen():
	gameInfo.addTitle()
	inputArea.visible = true
	room_music.battle_music(load("res://sounds/Music/character_select.mp3"))
	#_on_game_info_dialogue_ended_pass()

func _on_game_info_dialogue_ended_pass() -> void:
	gameInfo.removeTitle()
	room_music.battle_music(load("res://sounds/Music/Resting in the Torches Light.mp3"))
	room_music.volume_db = -11
	visualArea.visible = true
	side_panel.visible = false
	quitButton.visible = true
	characterSelect.visible = true
	playerInfo.visible = false
	areaPicture.visible = false
	inventoryArea.visible = false
	
	
	gameInfo.handleResponse("Select your flesh, it will only be temporary, this decision only has the weight you give to it.")
	gameInfo.handleResponse("Type confirm to continue.")
	


func characterSelectDescription(character: Resource):
	gameInfo.handleResponse(character.player_stats["Name"] +"\n"
	+ character.description + "\n" 
	+ "Health: " + str(character.player_stats["Health"]) + "\n"
	+ "Strength: " + str(character.player_stats["Strength"]) + "\n"
	+ "Intelligence: " + str(character.player_stats["Intelligence"]) + "\n"
	+ "Faith: " + str(character.player_stats["Faith"]) + "\n"
	+ "Will: " + str(character.player_stats["Will"]) + "\n"
	+ "Chance to hit: %s" %[(character.player_stats["Strength"] + character.player_stats["Will"]) * 12]
	)
	var starting_items = "Starting items: " 
	for i in character.starting_items:
		starting_items +=  character.starting_items[i].itemName + ", "
	gameInfo.handleResponse(starting_items)
	gameInfo.handleResponse("Type confirm to continue.")
	

func start_game():
	room_music.volume_db = 0
	side_panel.visible = true
	quitButton.visible = true
	visualArea.visible = true
	playerInfo.visible = true
	areaPicture.visible = true
	inventoryArea.visible = true
	characterSelect.visible = false
	for i in range(gameInfo.history_rows.get_child_count()):
		gameInfo.history_rows.get_child(i).queue_free()
	
	var startingResponse = command_Processor.initialize(room_manager.get_child(0), player)
	gameInfo.handleResponse("Welcome to Vermis: Lost Dungeon and Forbidden Woods!
You can type 'help' at any time to see a list of every available command!")
	gameInfo.handleResponse(startingResponse)
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_command_processor_quit() -> void:
	gameInfo.removeTitle()
	side_panel.visible = false
	quitButton.visible = true
	visualArea.visible = false
	playerInfo.visible = false
	areaPicture.visible = false
	inventoryArea.visible = false
	characterSelect.visible = false
	command_Processor.current_room = null
	inputArea.visible = true
	room_music.battle_music(load("res://sounds/Music/character_select.mp3"))
	#_on_game_info_dialogue_ended_pass()


func _on_command_processor_load_game() -> void:
	side_panel.visible = true
	quitButton.visible = true
	visualArea.visible = true
	playerInfo.visible = true
	areaPicture.visible = true
	inventoryArea.visible = true
	characterSelect.visible = false
	for i in range(gameInfo.history_rows.get_child_count()):
		gameInfo.history_rows.get_child(i).queue_free()
	gameInfo.handleResponse("Welcome to Vermis: Lost Dungeon and Forbidden Woods!
You can type 'help' at any time to see a list of every available command!")
