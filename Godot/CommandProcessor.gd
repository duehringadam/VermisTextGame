extends Node

signal room_changed(new_room)

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
	var thirdWord = ""
	
	if words.size() > 1:
		secondWord = words[1].to_lower()
	
	if words.size() > 2:
		thirdWord = words[2].to_lower()
	
	#process words
	match firstWord:
		"go":
			return go(secondWord,thirdWord)
		"help":
			return help()
		"take":
			return take(secondWord,thirdWord)
		"drop":
			return drop(secondWord,thirdWord)
		"inventory":
			return inventory()
		"use":
			return use(secondWord,thirdWord)
		"talk":
			return talk(secondWord,thirdWord)
		"give":
			return give(secondWord,thirdWord)
		"attack":
			return attack(secondWord,thirdWord)
		"inspect":
			return inspect(secondWord,thirdWord)
		_:
			return "Unrecognized Command."

func go(secondWord: String, thirdWord: String) -> String:
	if secondWord =="":
		return "Go Where?"
	elif secondWord =="" && thirdWord == "":
		return "Go Where?"
		
	if current_room.exits.keys().has(secondWord):
			var exit = current_room.exits[secondWord]
			if exit.isLocked:
				return "The path towards %s is locked!" % secondWord
			var changeResponse = changeRoom(exit.getOtherRoom(current_room))
			var output = PackedStringArray([
				"You go " + secondWord,
				"\n" + changeResponse
			])
			var output2 = "\n".join(output)
			return output2
			
	elif current_room.exits.keys().has(thirdWord):
		var exit = current_room.exits[thirdWord]
		if exit.isLocked:
			return "The path towards %s is locked!" % thirdWord
		var changeResponse = changeRoom(exit.getOtherRoom(current_room))
		var output = PackedStringArray([
			"You go " + thirdWord,
			"\n" + changeResponse
		])
		var output2 = "\n".join(output)
		return output2
	return "Your path is blocked!" 

func take(secondWord: String, thirdWord: String) -> String:
	
	if secondWord =="":
		return "Take what?"
	
	for item in current_room.items:
		if secondWord.to_lower() == item.itemName.to_lower():
			current_room.removeItem(item)
			player.takeItem(item)
			return "You take the "  + item.itemName + "!"
		
		if thirdWord.to_lower() == item.itemName.to_lower():
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
		Give [item],
		Attack [NPC]"

func changeRoom(new_room: GameRoom) -> String:
	current_room = new_room
	emit_signal("room_changed", new_room)
	return new_room.getFullRoom()

func drop(secondWord: String, thirdWord: String) ->String:
	if secondWord == "":
		return "Drop what?"
	
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			current_room.addItem(item)
			player.dropItem(item)
			return "You drop the "  + item.itemName + "!"
		if thirdWord.to_lower() == item.itemName.to_lower():
			current_room.addItem(item)
			player.dropItem(item)
			return "You drop the "  + item.itemName + "!"
	return "You don't currently have that item!"

func use(secondWord: String, thirdWord:String) -> String:
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
		if thirdWord.to_lower() == item.itemName.to_lower():
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

func talk(secondWord: String,thirdWord:String) -> String:
	if secondWord =="":
		return "Talk to who?"
	
	for npc in current_room.npcs:
		if npc.npcName.to_lower() == secondWord:
			var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.initalDialogue
			return npc.npcName + ": \"" + dialogue + "\"" 
		if npc.npcName.to_lower() == thirdWord:
			var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.initalDialogue
			return npc.npcName + ": \"" + dialogue + "\"" 
	return "%s is not currently in this room!" % secondWord

func give(secondWord: String,thirdWord:String) -> String:
	if secondWord =="":
		return "Give what?"
	
	var hasItem := false
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			hasItem = true
		if thirdWord.to_lower() == item.itemName.to_lower():
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
		
		if npc.questItem != null and thirdWord.to_lower() == npc.questItem.itemName.to_lower():
			npc.questItemReceived = true
			
			if npc.questReward != null:
				var reward = npc.questReward
				if "isLocked" in reward:
					reward.isLocked = false
				else:
					printerr("Quest reward type not implemented")
			
			for item in player.inventory:
				if thirdWord.to_lower() == item.itemName.to_lower():
					player.dropItem(item)
			return "You give the %s to the %s" % [secondWord, npc.npcName]
	return "No one wants that item here!"

func attack(secondWord: String,thirdWord:String) -> String:
	if secondWord =="":
		return "Attack what?"
	
	for npc in current_room.npcs:
		if npc.npcName.to_lower() == secondWord:
			npc.health -= player.damage
			player.health -= 1
			if npc.health >= 1:
				return "You deal %s damage to %s!
				%s deals 1 damage to you!" % [player.damage, npc.npcName,npc.npcName]
			elif npc.health < 1:
				current_room.removeNPC(npc)
				return "you kill %s!" % npc.npcName
			
		if npc.npcName.to_lower() == thirdWord:
			npc.health -= player.damage
			if npc.health >= 1:
				return "You deal %s damage to %s!
				%s deals 1 damage to you!" % [player.damage, npc.npcName,npc.npcName]
			elif npc.health < 1:
				current_room.removeNPC(npc)
				return "you kill %s!" % npc.npcName

	return "That character is not here to attack!"

func inspect(secondWord: String ,thirdWord: String):
	
	if secondWord =="":
		return "Inspect what?"
	
	for inspect in current_room.inspectables:
		if secondWord.to_lower() == inspect.inspectName.to_lower():
			return inspect.inspectDescription
		
		if thirdWord.to_lower() == inspect.inspectName.to_lower():
			return inspect.inspectDescription
		
	return "Nothing of note."
