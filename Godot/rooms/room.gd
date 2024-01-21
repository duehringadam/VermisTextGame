@tool
extends PanelContainer
class_name GameRoom

@export var roomName: String = "Room Name": set = setRoomName
@export_multiline var roomDescription: String = "Room Description": set = setRoomDescription
	
func setRoomName(newName):
	$MarginContainer/Rows/roomName.text = newName
	roomName = newName
func setRoomDescription(newDescription):
	$MarginContainer/Rows/roomDescription.text = newDescription
	roomDescription = newDescription

var exits: Dictionary = {}
var items: Array = []

func addItem(item: Item):
	items.append(item)
	
	
func getFullRoom():
	var fullRoom = PackedStringArray([
		getRoomName(),
		getRoomDescription(), 
		getItemDescription(),
		getRoomExit() 
	])
	var output = "\n".join(fullRoom)
	return output
	
func getRoomName():
	return "You are now in: " + roomName

func getRoomDescription():
	return roomDescription

func getRoomExit():
	var exitString = PackedStringArray(
		exits.keys()
		)
	return "Exits: " + ",".join(exitString)

func getItemDescription():
	if items.size() == 0:
		return "Nothing of note in the vicinity."
	
	var itemsString = ""
	
	for item in items:
		itemsString += item.itemName + " "
	
	return "Items: " + itemsString

func connectExit(direction: String, room: GameRoom):
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exits[direction] = exit
	
	
	match direction:
		"west","left":
			room.exits["east"] = exit
		"east","right":
			room.exits["west"] = exit
		"north","forward","straight":
			room.exits["south"] = exit
		"south","backwards","back":
			room.exits["north"] = exit
		_:
			printerr("invalid direction %s", direction)
