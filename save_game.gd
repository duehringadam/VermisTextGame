extends Node

@onready var game = $".."
@onready var player = $"../Player"
@onready var commandProcessor = $"../CommandProcessor"

var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"

var playerdata = PlayerData.new()

func _ready() -> void:
	verify_save_directory(save_file_path)
	

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func updateGame():
	for i in playerdata.inventory:
		#print(i)
		game.inventoryArea._on_command_processor_item_taken(i)
	for i in playerdata.equipped_items.values():
		if i != null:
			game.inventoryArea._on_player_item_equipped(i)

func updatePlayer():
	#print(player.inventory)
	player.player_stats = playerdata.player_stats
	player.inventory = playerdata.inventory
	player.equipped_items = playerdata.equipped_items
	
	

func updateRoom():
	var savedroom = get_node("/root/Game/Room Manager/" + playerdata.current_room["Name"])
	savedroom.npcs = playerdata.current_room["NPCS"]
	savedroom.items = playerdata.current_room["Items"]
	commandProcessor.changeRoom(savedroom)

func _on_command_processor_load_game():
	playerdata = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	updatePlayer()
	updateRoom()
	updateGame()
	#print(player.equipped_items)
	#print(player.inventory)

func _on_command_processor_save_game():
	ResourceSaver.save(playerdata,save_file_path + save_file_name)
	#updatePlayer()
	updateRoom()


func _on_player_stats_changed(player_stats: Variant) -> void:
	playerdata.save_stats(player_stats)


func _on_command_processor_room_changed(new_room: Variant) -> void:
	playerdata.save_room(new_room)
	#print(playerdata.current_room_name)


func _on_command_processor_item_taken(item: Variant) -> void:
	playerdata.save_inventory(item)


func _on_player_save_equipped(equipped_items: Variant) -> void:
	playerdata.save_equipped(equipped_items)


func _on_command_processor_item_dropped(item: Variant) -> void:
	playerdata.save_inventory_dropped(item)
