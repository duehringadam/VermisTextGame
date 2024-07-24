extends Node

signal room_changed(new_room)
signal item_taken(player)
signal item_dropped(player)
signal save_game
signal load_game
signal item_unequipped(item)

@onready var characterSelect = $"../Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/character select"
var current_room = null
var i = 0
@onready var player = $"../Player"
@onready var combat = $"../Combat"
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
	if current_room == null:
		match firstWord:
			"confirm":
				return confirm()
			_: 
				return "You cannot do that right now!"
	if combat.combatInitiated == true:
		match firstWord:
			"attack":
				return attack(secondWord,thirdWord)
			"talk":
				return talk(secondWord,thirdWord)
			"run":
				return run()
			_:
				return "You cannot do that while in combat!"
				
	if current_room != null:
		if player.status_effects["Insanity"] == false && player.status_effects["Slumber"] == false:
			match firstWord:
				"go":
					return go(secondWord,thirdWord)
				"help":
					return help()
				"take":
					return take(secondWord,thirdWord)
				"drop":
					return drop(secondWord,thirdWord)
				"equip":
					return equip(secondWord,thirdWord)
				"unequip":
					return unequip(secondWord,thirdWord)
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
				"save":
					return save()
				"load":
					return load_player_save()
				"confirm":
					return confirm()
				"run":
					return run()
				_:
					return "Unrecognized Command."
	elif player.status_effects["Insanity"] == true:
		return "Hahaha...!"
	if player.status_effects["Slumber"] == true:
		return "You are asleep."

func run() -> String:
	return combat.run()

func confirm() -> String:
	if characterSelect.visible == true && CharacterSelectManager.select_bool == true:
		return "What has been done cannot be undone."
	elif characterSelect.visible == true && CharacterSelectManager.select_bool == false:
		return "No character selected."
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
			emit_signal("item_taken", item)
			return "You take the "  + item.itemName + "!"
			
		
		if thirdWord.to_lower() == item.itemName.to_lower():
			current_room.removeItem(item)
			player.takeItem(item)
			emit_signal("item_taken", item)
			return "You take the "  + item.itemName + "!"
			
		
	return "Item not found!"

func inventory() -> String:
	return player.getInventory()

func equip(secondWord,thirdWord) -> String:
	if secondWord == "":
		return "Equip what?"
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower() or thirdWord.to_lower() == item.itemName.to_lower():
			if item.isEquipped == false:
				return player.equipItem(item)
			else:
				return "%s already equipped!" % [item.itemName]
	return "Item not found!"

func unequip(secondWord,thirdWord) -> String:
	if secondWord == "":
		return "Unequip what?"
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower() or thirdWord.to_lower() == item.itemName.to_lower():
			emit_signal("item_unequipped", item)
			return player.unequipItem(item)
	return "Item not found!"

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
		Attack [NPC],
		Inspect [thing]"

func changeRoom(new_room: GameRoom) -> String:
	current_room = new_room
	emit_signal("room_changed", new_room)
	for npc in current_room.npcs:
		if npc.isEnemy == true:
			return combat.initialize(npc, player)
	return new_room.getFullRoom()

func drop(secondWord: String, thirdWord: String) ->String:
	if secondWord == "":
		return "Drop what?"
	
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			current_room.addItem(item)
			player.dropItem(item)
			emit_signal("item_dropped", item)
			return "You drop the "  + item.itemName + "!"
		if thirdWord.to_lower() == item.itemName.to_lower():
			current_room.addItem(item)
			player.dropItem(item)
			emit_signal("item_dropped", item)
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
			if i < npc.dialogue.size():
				var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.dialogue[i]
				i += 1
				return npc.npcName + ": \"" + dialogue + "\"" 
			elif i >= npc.dialogue.size():
				return npc.npcName + ": \"" + npc.dialogue.back() + "\""
		if npc.npcName.to_lower() == thirdWord:
			if i < npc.dialogue.size():
				var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.dialogue[i]
				i += 1
				return npc.npcName + ": \"" + dialogue + "\"" 
			elif i >= npc.dialogue.size():
				return npc.npcName + ": \"" + npc.dialogue.back() + "\""
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
		
	if player.status_effects["Dread"] == false:
		for npc in current_room.npcs:
			if npc.npcName.to_lower() == secondWord && combat.combatInitiated == false:
				return combat.initialize(npc, player)
				
			if npc.npcName.to_lower() == thirdWord && combat.combatInitiated == false:
				return combat.initialize(npc, player)
			
			if npc.npcName.to_lower() == secondWord && combat.combatInitiated == true:
				return combat.attack(npc, player)
				
			if npc.npcName.to_lower() == thirdWord && combat.combatInitiated == true:
				return combat.attack(npc, player)
	else:
		return "You are too afraid to attack!"

	return "That character is not here to attack!"

func inspect(secondWord: String ,thirdWord: String):
	if secondWord =="":
		return "Inspect what?"
	
	for item in player.inventory:
		if secondWord.to_lower() == item.itemName.to_lower():
			return item.itemDescription
	
	for inspect in current_room.inspectables:
		if secondWord.to_lower() == inspect.inspectName.to_lower():
			return inspect.inspectDescription
		
		if thirdWord.to_lower() == inspect.inspectName.to_lower():
			return inspect.inspectDescription
		
	return "Nothing of note."

func save():
	emit_signal("save_game")
	return "Game saved!"
	

func load_player_save():
	emit_signal("load_game")
	return "loading game..."
