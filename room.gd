@tool
extends PanelContainer
class_name GameRoom

@onready var player = $"../../Player"
@export var roomName: String = "Room Name": set = setRoomName
@export_multiline var roomDescription: String = "Room Description": set = setRoomDescription
@export var isSecret := false
@export var areaPicture: Texture2D
@export var hasEnemy := false
@export var music: AudioStream

func _ready():
	pass

func setRoomName(newName):
	$MarginContainer/Rows/roomName.text = newName
	roomName = newName

func setRoomDescription(newDescription):
	$MarginContainer/Rows/roomDescription.text = newDescription
	roomDescription = newDescription

var exits: Dictionary = {}
var npcs: Array = []
var items: Array = []
var inspectables: Array = []

func addNPC(npc: NPC):
	npcs.append(npc)

func removeNPC(npc: NPC):
	npcs.erase(npc)

func addItem(item: Item):
	items.append(item)

func removeItem(item: Item):
	items.erase(item)

func addInspect(inspect: Inspect):
	inspectables.append(inspect)

func removeInspect(inspect: Inspect):
	inspectables.erase(inspect)

func getFullRoom():
	var fullRoom = PackedStringArray([getRoomName(),getRoomDescription()])
	var itemDescription = getItemDescription()
	var npcDescription = getNPCDescription()
	
	if npcDescription != "":
		fullRoom.append(npcDescription)
	
	if itemDescription != "":
		fullRoom.append(itemDescription)
	
	fullRoom.append(getRoomExit())
	
	var output = "\n".join(fullRoom)
	
	if player.status_effects["Blindness"] == true:
		return "You cannot see."
	else:
		return output
	
func getRoomName():
	return "You are now in: " + roomName + "\n"

func getRoomDescription():
	return roomDescription

func getRoomExit():
	var exitString = PackedStringArray(
		exits.keys()
		)
	return "\n"+"Exits: " + ",".join(exitString)

func getNPCDescription() -> String:
	if npcs.size() == 0:
		return ""
	else:
		var npcString = ""
		for npc in npcs:
			npcString += npc.npcName + " "
		return "NPCS: " + npcString

func getItemDescription():
	if items.size() == 0:
		return ""
	
	var itemsString = ""
	
	for item in items:
		itemsString += item.itemName + " "
	
	return "Items: " + itemsString

func connectExitUnlocked(direction: String, room: GameRoom, room_2_Override: String = "null"):
	return _connectExit(direction, room, false, false, room_2_Override)

func connectExitLocked(direction: String, room: GameRoom, room_2_Override: String = "null"):
	return _connectExit(direction, room, true, false, room_2_Override)


func _connectExit(direction: String, room: GameRoom, is_locked: bool = false, secret := false, room_2_Override: String = "null"):
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exit.isLocked = is_locked
	exits[direction] = exit
	
	#if override name exists
	if room_2_Override != "null":
		room.exits[room_2_Override] = exit
	else:
		match direction:
			"west":
				room.exits["east"] = exit
			"east":
				room.exits["west"] = exit
			"north":
				room.exits["south"] = exit
			"south":
				room.exits["north"] = exit
			"inside":
				room.exits["outside"] = exit
			"left":
				room.exits["right"] = exit
			"right":
				room.exits["left"] = exit
			"path":
				room.exits["path"] = exit
			"outisde":
				room.exits["inside"] = exit
			"forward":
				room.exits["back"] = exit
			_:
				printerr("invalid direction %s", direction)
	return exit
	
