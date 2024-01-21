extends Node

#signal response_generated(response_text)

var current_room = null

func initialize(starting_room) -> String:
	return changeRoom(starting_room)

func processCommand(input: String):
	#read words into array
	var words = input.split(" ", false)
	if words.size() == 0:
		return "No command entered"
	#create word variables
	var firstWord = words[0].to_lower()
	var secondWord = ""
	
	if words.size() > 1:
		secondWord = words[1].to_lower()
	
	#process words
	match firstWord:
		"go":
			return go(secondWord)
		"help":
			return help()
		_:
			return "Unrecognized Command."


func go(secondWord: String) -> String:
	if secondWord =="":
		return "Go Where?"
		
	if current_room.exits.keys().has(secondWord):
		var exit = current_room.exits[secondWord]
		var changeResponse = changeRoom(exit.getOtherRoom(current_room))
		var output = PackedStringArray([
			"You go " + secondWord,
			" " + changeResponse
		])
		var output2 = "\n".join(output)
		return output2
			
	else:
		return "Your path is blocked!" 


func help() -> String:
	return "You can use these commands:
		Go [direction],
		Help"


func changeRoom(newRoom: GameRoom) -> String:
	current_room = newRoom
	return newRoom.getFullRoom()
