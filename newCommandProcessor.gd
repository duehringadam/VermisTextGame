extends Node


signal room_changed(new_room)
signal item_taken(player)
signal save_game
signal load_game
signal item_unequipped(item)
signal npc_talk(npc)
signal confirm_select
signal item_dropped(item)
signal new_character
signal quit

@onready var characterSelect = $"../Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/character select"
@onready var current_room = $"../Room Manager/Isolated Crypt"
var i = 0
@onready var player = $"../Player"
@onready var combat = $"../Combat"
#dict of keys to look for

var keys:Dictionary = {
		"Go": {"Keywords": ["Go","Move","Enter","Proceed","Walk","Step"],"func": go},
		"Help": {"Keywords": ["Help"],"func": help},
		"Inventory": {"Keywords": ["Inventory"], "func": inventory},
		"Take": {"Keywords": ["Take","Pick","Grab"], "func": take},
		"Drop": {"Keywords": ["Drop","Throw away"], "func": drop},
		"Use": {"Keywords": ["Use","Insert","Place"], "func": use},
		"Equip": {"Keywords": ["Equip","Put on"], "func": equip},
		"Unequip": {"Keywords": ["Unequip"], "func": unequip},
		"Talk": {"Keywords":["Talk", "Speak", "Converse"],"func": talk},
		"Give": {"Keywords":["Give", "Gift"], "func": give},
		"Attack":{"Keywords": ["Attack", "Strike", "Assault"],"func": attack},
		"Run": {"Keywords":["Run", "Retreat", "Withdraw", "Flee"],"func":run},
		"Inspect": {"Keywords": ["Inspect","Look","Examine","View","Observe"], "func": inspect},
		"Save": {"Keywords":["Save"], "func": save},
		"Load": {"Keywords":["Load"], "func": loadgame}
		}


func initialize(starting_room, player) -> String:
	self.player = player
	return changeRoom(starting_room)

var foundCommand = 0

func process_command(_input: String) -> String:
	#load input words into an array
	var words:Array = _input.to_lower().split(" ", false)
	var storedwords:String
	
		
	
	if words.size() == 0:
		return "No command entered!"
		
	var check:Dictionary = {}
	
	for key in keys.values():
		if foundCommand == 0:
			for i in key["Keywords"]:
				check[i] = words.has(i.to_lower())
				if check[i]:
					#print(i)
					foundCommand = 1
					key.get("func").call(_input)
	
	if foundCommand != 0:
		return "Too many commands!"
	
	return "Unrecognized Command!"

func go(words) -> String:
	#print(words)
	#print(current_room.exits.keys())
	
	for i in words:
		if current_room != null:
			if current_room.exits.keys().has(i):
				#print("lalala")
				var exit = current_room.exits[i]
				if exit.isLocked:
					return "The path towards %s is locked!" % words
				var changeResponse = changeRoom(exit.getOtherRoom(current_room))
				var output = PackedStringArray([
					"You go " + i,
					"\n" + changeResponse
				])
				var output2 = "\n".join(output)
				#print(output2)
				return output2
			elif current_room.secret_exits.keys().has(i):
				var exit = current_room.exits[i]
				if exit.isLocked:
					return "The path towards %s is locked!" % words
				var changeResponse = changeRoom(exit.getOtherRoom(current_room))
				var output = PackedStringArray([
					"You go " + i,
					"\n" + changeResponse
				])
				var output2 = "\n".join(output)
				#print(output2)
				return output2
	return "No room!"

func changeRoom(new_room: GameRoom) -> String:
	current_room = new_room
	emit_signal("room_changed", new_room)
	for npc in current_room.npcs:
		if npc.isEnemy:
			return combat.initialize(npc, player)
	return new_room.getFullRoom()


func help(words) -> String:
	#print("You can use the following commands")
	return "You can use the following commands"
	for i in keys.keys():
		#print(i)
		return i

func inventory(words) -> String:
	#print(player.getInventory())
	return player.getInventory()

func take(words) -> String:
	if current_room!=null:
		for i in words:
			for item in current_room.items:
				if i == item.itemName:
					current_room.removeItem(item)
					player.takeItem(item)
					emit_signal("item_taken", item)
					#print("You take the "  + item.itemName + "!")
					return("You take the "  + item.itemName + "!")
			#print("Item not found!")
			return("Item not found!")
	return "No room!"

func drop(words)-> String:
	
	for i in words:
		for item in player.inventory:
			#print(i)
			if i.to_lower() == item.itemName.to_lower():
				current_room.addItem(item)
				emit_signal("item_dropped", item)
				#print("You dropped the item!")
				return player.dropItem(item)
		#print("You don't currently have that item!")
	return "You don't currently have that item!"

func use(words)-> String:
	for i in words:
		for item in player.inventory:
			if i.to_lower() == item.itemName.to_lower():
				match item.itemType:
					#match statement for item types
					Types.ItemTypes.KEY:
						for exit in current_room.secret_exits.values():
							if exit == item.useValue:
								exit.isLocked = false
								player.dropItem(item)
								return "You used the %s to unlock the %s!" %[item.itemName, exit.getOtherRoom(current_room).roomName]
						for exit in current_room.exits.values():
							if exit == item.useValue:
								exit.isLocked = false
								player.dropItem(item)
								return "You used the %s to unlock the %s!" %[item.itemName, exit.getOtherRoom(current_room).roomName]
						return "That key does not unlock this path!"
					Types.ItemTypes.CONSUMABLE:
						player.inventory.erase(item)
						emit_signal("item_dropped", item)
						return player.updateImmunity(item.effect_nullify)
					_:
						return "Item has no use here!"
	#print("You don't have that item to use!")
	return "You don't have that item to use!" 

func give(words)-> String:
	var hasItem := false
	
	for i in words:
		for item in player.inventory:
			if i.to_lower() == item.itemName.to_lower():
				hasItem = true
	
	if not hasItem:
		#print("You dont have that item to give!")
		return "You don't have that item to give!"
	for i in words:
		for npc in current_room.npcs:
			if npc.questItem != null and i.to_lower() == npc.questItem.itemName.to_lower():
				npc.questItemReceived = true
				
				if npc.questReward != null:
					var reward = npc.questReward
					if "isLocked" in reward:
						reward.isLocked = false
					if reward is Item:
						#print("test test")
						#print(reward)
						player.takeItem(reward)
						emit_signal("item_taken", reward)
					else:
						printerr("Quest reward type not implemented")
				
				for item in player.inventory:
					if i.to_lower() == item.itemName.to_lower():
						#print(i)
						#print(item.itemName)
						emit_signal("item_dropped", item)
						return player.dropItem(item)
						
				return "You give the %s to the %s" % [i, npc.npcName]
	#print("No one wants that item here!")
	return "No one wants that item here!"

func inspect(words)-> String:
	for i in words:
		for item in player.inventory:
			if i.to_lower() == item.itemName.to_lower():
				return item.itemDescription
				
		for inspect in current_room.inspectables:
			if i.to_lower() == inspect.inspectName.to_lower():
				return inspect.inspectDescription
			
		for npc in current_room.npcs:
			if i.to_lower() == npc.npcName.to_lower():
				return npc.npcDescription
	#print("Nothing of note.")
	return "Nothing of note."

func equip(words)-> String:
	
	for i in words:
		for item in player.inventory:
			if i.to_lower() == item.itemName.to_lower():
				if item.isEquipped == false:
					if combat.combatInitiated:
						combat.equipItem(item)
					return player.equipItem(item)
				else:
					return "%s already equipped!" % [item.itemName]
	#print("item not found!")
	return "Item not found!"

func unequip(words)-> String:
	for i in words:
		for item in player.inventory:
			if i.to_lower() == item.itemName.to_lower():
				emit_signal("item_unequipped", item)
				return player.unequipItem(item)
	#print("Item not found!")
	return "Item not found!"

func attack(storedwords)-> String:
	#print(storedwords)
	if player.status_effects["Dread"] == false:
		
		for i in storedwords:
			for npc in current_room.npcs:
				
				if npc.npcName.to_lower() == i && combat.combatInitiated == false:
					return combat.initialize(npc, player)
					
				if npc.npcName.to_lower() == i && combat.combatInitiated == true:
					return combat.attack(npc, player)
					
	else:
		return "You are too afraid to attack!"
	#print("That character is not here to attack!")
	return "That character is not here to attack!"

func talk(words)-> String:
	for i in words:
		for npc in current_room.npcs:
			if npc.npcName.to_lower() == i:
				emit_signal("npc_talk", npc)
				if i < npc.dialogue.size():
					var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.dialogue[i]
					i += 1
					return npc.npcName + ": \"" + dialogue + "\"" 
				elif i >= npc.dialogue.size():
					return npc.npcName + ": \"" + npc.dialogue.back() + "\""
		#print("%s is not currently in this room!" % words[1])
		return "%s is not currently in this room!" % words[1]
	return "null"

func cast(words):
	for i in words:
		if !player.status_effects["Dread"]:
			for npc in current_room.npcs:
				if combat.combatInitiated:
					if npc.npcName.to_lower() == i:
						return combat.spell(npc, player, player.equipped_items["Spell"])
					if npc.npcName.to_lower() == i:
						return combat.spell(npc, player, player.equipped_items["Spell"])
				else:
					return "You must be in combat to do that!"
		else:
			return "You are too afraid to cast!"
		
	return "That character is not here to attack!"


func run(words):
	return combat.run()


func save(words):
	emit_signal("save_game")
	return "Game saved!"


func loadgame(words):
	emit_signal("load_game")
	return "Loading game...(if it doesnt work automatically then you have no current save!)"

