extends Resource
class_name Exit

var room_1: GameRoom = null
var room_1_isLocked := false

var room_2: GameRoom = null
var room_2_isLocked := false


func getOtherRoom(currentRoom: GameRoom):
	if currentRoom == room_1:
		return room_2
	elif currentRoom == room_2:
		return room_1
	else:
		printerr("The room you tried to find is not connected to this exit.")
		return null
