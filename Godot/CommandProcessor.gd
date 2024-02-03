extends Node

signal room_changed

var current_room = null
var player = null

func initialize(starting_room, player) -> String:
	self.player = player
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
		"take":
			return take(secondWord)
		"drop":
			return drop(secondWord)
		"inventory":
			return inventory()
		"use":
			return use(secondWord)
		"talk":
			return talk(secondWord)
		"give":
			return give(secondWord)
		_:
			return "Unrecognized Command."

func go(secondWord: String) -> String:
	if secondWord =="":
		return "Go Where?"
		
	if current_room.exits.keys().has(secondWord):
		var exit = current_room.exits[secondWord]
		if exit.isLocked:
			return "The path towards %s is locked!" % secondWord
		var changeResponse = changeRoom(exit.getOtherRoom(current_room))
		var output = PackedStringArray([
			"You go " + secondWord,
			" " + changeResponse
		])
		var output2 = "\n".join(output)
		return output2
			
	else:
		return "Your path is blocked!" 

func take(secondWord: String) -> String:
	
	if secondWord =="":
		return "Take what?"
	
	for item in current_room.items:
		if secondWord.to_lower() == item.itemName.to_lower():
			current_room.removeItem(item)
			player.takeItem(item)
			return "You take the "  + item.itemName + "!"
		
	return "Item not found!"

func inventory() -> String:
	return player.getInventory()

func help() -> String:
	return "You can use these commands:
		Go [direction],
		Help,
		Inventory,
		Take [item],
		Drop [item],
		Use [item],
		Talk [character],
		Give [item]"

func changeRoom(newRoom: GameRoom) -> String:
	current_room = newRoom
	emit_signal("room_changed", newRoom)
	return newRoom.getFullRoom()
	

func drop(secondWord: String) ->String:
	if secondWord == "":
		return "Drop what?"
	
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			current_room.addItem(item)
			player.dropItem(item)
			return "You drop the "  + item.itemName + "!"
	return "You don't currently have that item!"

func use(secondWord: String) -> String:
	if secondWord =="":
		return "Use what?"
	
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			match item.itemType:
				#match statement for item types
				Types.ItemTypes.KEY:
					for exit in current_room.exits.values():
						if exit == item.useValue:
							exit.isLocked = false
							player.dropItem(item)
							return "You used the %s to unlock the %s!" %[item.itemName, exit.getOtherRoom(current_room).roomName]
					return "That key does not unlock this path!"
				_:
					return "Item has no use here!" 
		
	return "You don't have that item!" 

func talk(secondWord: String) -> String:
	if secondWord =="":
		return "Talk to who?"
	
	for npc in current_room.npcs:
		if npc.npcName.to_lower() == secondWord:
			var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.initalDialogue
			return npc.npcName + ": \"" + dialogue + "\"" 
	return "%s is not currently in this room!" % secondWord

func give(secondWord: String) -> String:
	if secondWord =="":
		return "Give what?"
	
	var hasItem := false
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			hasItem = true
	
	if not hasItem:
		return "You don't have that item to give!"
	
	for npc in current_room.npcs:
		if npc.questItem != null and secondWord.to_lower() == npc.questItem.itemName.to_lower():
			npc.questItemReceived = true
			
			if npc.questReward != null:
				var reward = npc.questReward
				if "isLocked" in reward:
					reward.isLocked = false
				else:
					printerr("Quest reward type not implemented")
			
			for item in player.inventory:
				if secondWord.to_lower() == item.itemName.to_lower():
					player.dropItem(item)
			return "You give the %s to the %s" % [secondWord, npc.npcName]
	return "No one wants that item here!"
