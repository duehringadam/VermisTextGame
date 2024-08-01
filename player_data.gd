extends Resource

class_name PlayerData

@export var inventory: Array = []

@export var equipped_items = {
	"Weapon": null,
	"Armor": null,
	"Jewelry": null,
	"Spell": null
}
@export var player_stats = {
	"Name": "",
	"Health": 1,
	"Max Health": null,
	"Strength": null,
	"Intelligence": null,
	"Faith": null,
	"Will": null,
	"Damage": 1
}
@export var current_room_name: String

@export var current_room = {
	"Room Name": "",
	"NPCS": null,
	"Items":null
}

func save_stats(data):
	player_stats["Name"] = data["Name"]
	player_stats["Health"] = data["Health"]
	player_stats["Max Health"] = data["Max Health"]
	player_stats["Strength"] = data["Strength"]
	player_stats["Intelligence"] = data["Intelligence"]
	player_stats["Faith"] = data["Faith"]
	player_stats["Will"] = data["Will"]
	player_stats["Damage"] = data["Damage"]
	
	
func save_equipped(data):
	equipped_items["Weapon"] = data["Weapon"]
	equipped_items["Armor"] = data["Armor"]
	equipped_items["Jewelry"] = data["Jewelry"]
	equipped_items["Spell"] = data["Spell"]
	
func save_inventory(data):
	inventory.append(data)

func save_inventory_dropped(data):
	inventory.erase(data)

func save_room(data):
	current_room_name = data.roomName
	current_room["Name"] = data.roomName
	current_room["NPCS"] = data.npcs
	current_room["Items"] = data.items
	#print(current_room)
