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
@onready var current_room = null
var i = 0
var already_talked = 0
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
		"Attack":{"Keywords": ["Attack", "Strike", "Assault", "Hit"],"func": attack},
		"Run": {"Keywords":["Run", "Retreat", "Withdraw", "Flee"],"func":run},
		"Inspect": {"Keywords": ["Inspect","Look","Examine","View","Observe","Read"], "func": inspect},
		"Save": {"Keywords":["Save","Rest"], "func": save},
		"Load": {"Keywords":["Load"], "func": loadgame},
		"New": {"Keywords":["New","Character"], "func": new},
		"Quit":{"Keywords":["Quit", "Exit"], "func": quitGame},
		"Confirm":{"Keywords":["Confirm"], "func": confirm},
		"Cast":{"Keywords":["Cast"], "func": cast},
		"Journal":{"Keywords":["Journal"], "func": journal}
		}

var keys_title_screen = {
	"Load": {"Keywords":["Load"], "func": loadgame},
	"New": {"Keywords":["New","Character"], "func": new},
	"Quit":{"Keywords":["Quit", "Exit"], "func": quitGame},
	"Confirm":{"Keywords":["Confirm"], "func": confirm}
}

var keys_player_insane = {
	"Attack":{"Keywords": ["Attack", "Strike", "Assault", "Hit"],"func": attack},
	"Run": {"Keywords":["Run", "Retreat", "Withdraw", "Flee"],"func":run},
	"Cast":{"Keywords":["Cast"], "func": cast},
	"Quit":{"Keywords":["Quit", "Exit"], "func": quitGame}
}

var keys_player_asleep = {
	"Attack":{"Keywords": ["Attack", "Strike", "Assault", "Hit"],"func": attack},
	"Run": {"Keywords":["Run", "Retreat", "Withdraw", "Flee"],"func":run},
	"Cast":{"Keywords":["Cast"], "func": cast},
	"Quit":{"Keywords":["Quit", "Exit"], "func": quitGame}
}

func initialize(starting_room, player) -> String:
	self.player = player
	return changeRoom(starting_room)

var foundCommand = 0

func processCommand(_input: String) -> String:
	foundCommand = 0
	#load input words into an array
	var words:Array = _input.to_lower().split(" ", false)
	
	if words.size() == 0:
		return "No command entered!"
		
	var check:Dictionary = {}
	
	#title screen keys
	if current_room == null:
		for key in keys_title_screen.values():
			if foundCommand == 0:
				for i in key["Keywords"]:
					check[i] = words.has(i.to_lower())
					if check[i]:
						#print(i)
						foundCommand = 1
						return key.get("func").call(_input)
		return "You cannot do that right now!"
	
	#player status effects keys
	if player.status_effects["Insanity"]:
		for key in keys_player_insane.values():
			if foundCommand == 0:
				for i in key["Keywords"]:
					check[i] = words.has(i.to_lower())
					if check[i]:
						#print(i)
						foundCommand = 1
						return key.get("func").call(_input)
		return "Hahaha...!"
	
	if player.status_effects["Slumber"]:
		for key in keys_player_asleep.values():
			if foundCommand == 0:
				for i in key["Keywords"]:
					check[i] = words.has(i.to_lower())
					if check[i]:
						#print(i)
						foundCommand = 1
						return key.get("func").call(_input)
		return "You are asleep!"
	

	#normal keys
	for key in keys.values():
		if foundCommand == 0:
			for i in key["Keywords"]:
				check[i] = words.has(i.to_lower())
				if check[i]:
					#print(i)
					foundCommand = 1
					return key.get("func").call(_input)
					
		if foundCommand > 0:
			return "Too many commands!"		
	return "Unrecognized command!"
	
func confirm(_words):
	if characterSelect.visible == true && CharacterSelectManager.select_bool == true:
		emit_signal("confirm_select")
		return "What has been done cannot be undone."
	elif characterSelect.visible == true && CharacterSelectManager.select_bool == false:
		return "No character selected!"
	return "Unrecognized command"

func new(_words) -> String:
		
	if current_room == null:
		emit_signal("new_character")
		return "New Character"
	else:
		return "You cannot do that right now!"
	

func go(words) -> String:
	if combat.combatInitiated:
		return "You cannot do that while in combat!"
	
	for i in current_room.exits.keys():
		if words.contains(i):
			var exit = current_room.exits[i]
			if exit.isLocked:
				return "The path towards %s is locked!" % words
			var changeResponse = changeRoom(exit.getOtherRoom(current_room))
			var output = PackedStringArray([
				"You go " + i,
				"\n" + changeResponse
			])
			var output2 = "\n".join(output)
			return output2
	for i in current_room.secret_exits.keys():
		if words.contains(i):
			var exit = current_room.secret_exits[i]
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
	return "Your path is blocked!"

func changeRoom(new_room: GameRoom) -> String:
	var entry
	already_talked = 0
	current_room = new_room
	emit_signal("room_changed", new_room)
	for npc in current_room.npcs:
		if npc.isEnemy:
			return combat.initialize(npc, player)
	if current_room.journal_entry != null:
		AudioManager.play_sound(load("res://sounds/SFX/journal save.mp3"))
		entry = current_room.journal_entry
	return new_room.getFullRoom() + "\n" + "\n" + player.add_journal(entry)

func help(_words) -> String:
	var output = ""
	for i in keys.keys():
		#print(i)
		output += i + ", "
	return "You can use the following commands:" + "\n" + output

func inventory(_words) -> String:
	return player.getInventory()

func take(words) -> String:
	if current_room == null:
		return "You cannot do that right now!"
	for item in current_room.items:
		if words.contains(item.itemName.to_lower()):
			current_room.removeItem(item)
			player.takeItem(item)
			emit_signal("item_taken", item)
			return("You take the "  + item.itemName + "!")
	return("Item not found!")

func drop(words)-> String:
	for item in player.inventory:
		if words.contains(item.itemName.to_lower()):
			return player.dropItem(item)
	return "You don't currently have that item!"

func use(words)-> String:
	for item in player.inventory:
		if words.contains(item.itemName.to_lower()):
			match item.itemType:
				#match statement for item types
				Types.ItemTypes.KEY:
					AudioManager.play_sound(load("res://sounds/SFX/powerUp.wav"))
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
					AudioManager.play_sound(load("res://sounds/SFX/powerUp.wav"))
					if item.uses >= 0:
						var output = ""
						item.uses -= 1
						player.player_stats["Health"] += item.amount_healed
						player.player_stats["Damage"] += item.damage_increase
						player.chance_to_hit += item.increase_to_chance_hit
						if item.uses-1 < 0:
							player.inventory.erase(item)
							emit_signal("item_dropped", item)
						if !item.amount_healed == 0:
							output += player.heal(item.amount_healed)+"\n" 
						if item.effect_nullify != "":
							output += player.updateImmunity(item.effect_nullify)+"\n"
						if item.damage_increase != 0:
							output += player.buff()+"\n"
						return output
				_:
					return "Item has no use here!"
	return "You don't have that item to use!" 

func give(words)-> String:
	var hasItem := false
	
	for item in player.inventory:
		if words.contains(item.itemName.to_lower()):
			hasItem = true
	
	if not hasItem:
		return "You don't have that item to give!"
	
	for npc in current_room.npcs:
		if npc.questItem != null and words.contains(npc.questItem.itemName.to_lower()):
			npc.questItemReceived = true
			
		if npc.questReward != null:
			var reward = npc.questReward
			if "isLocked" in reward:
				reward.isLocked = false
			if reward is Item:
					#print("test test")
					#print(reward)
					#player.takeItem(reward)
					emit_signal("item_taken", reward)
			else:
				printerr("Quest reward type not implemented")
				
			for item in player.inventory:
				if words.contains(item.itemName.to_lower()):
					emit_signal("item_dropped", item)
					player.takeItem(item)
					player.inventory.erase(item)
					return "You give the %s to the %s" % [item.itemName,npc.npcName]
	#print("No one wants that item here!")
	return "No one wants that item here!"

func inspect(words)-> String:
	var output
	for item in player.inventory:
		if words.contains(item.itemName.to_lower()):
			return item.itemDescription + "\n" + "Required Stats: " + str(item.required_Stats)
				
	for inspect in current_room.inspectables:
		if words.contains(inspect.inspectName.to_lower()):
			if inspect.journal != null:
				AudioManager.play_sound(load("res://sounds/SFX/journal save.mp3"))
			return inspect.inspectDescription + "\n" + "\n"+player.add_journal(inspect.journal)
		
	for npc in current_room.npcs:
		if words.contains(npc.npcName.to_lower()):
			return npc.npcDescription
	return "Nothing of note."

func equip(words)-> String:
	for item in player.inventory:
		if words.contains(item.itemName.to_lower()):
			if item.isEquipped == false:
				if combat.combatInitiated:
					combat.equipItem(item)
				return player.equipItem(item)
			else:
				return "%s already equipped!" % [item.itemName]
	#print("item not found!")
	return "Item not found!"

func unequip(words)-> String:
	for item in player.inventory:
		if words.contains(item.itemName.to_lower()):
			emit_signal("item_unequipped", item)
			return player.unequipItem(item)
	#print("Item not found!")
	return "Item not found!"

func attack(words)-> String:
	if words == "attack" && combat.combatInitiated == false:
		return "Attack who?"
	
	if words == "attack" && combat.combatInitiated == true:
		for npc in current_room.npcs:
			return combat.attack(npc, player)
	
	if player.status_effects["Dread"] == false:
			for npc in current_room.npcs:
				if words.contains(npc.npcName.to_lower()) && combat.combatInitiated == false:
					return combat.initialize(npc, player)
					
				if words.contains(npc.npcName.to_lower()) && combat.combatInitiated == true:
					return combat.attack(npc, player)
	else:
		return "You are too afraid to attack!"
	return "That character is not here to attack!"

func talk(words)-> String:
	if words == "talk" && combat.combatInitiated == false && already_talked == 0:
		return "Talk to who?"
	
	if words == "talk" && combat.combatInitiated == false && already_talked > 0:
		for npc in current_room.npcs:
			emit_signal("npc_talk", npc)
			if i < npc.dialogue.size():
				var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.dialogue[i]
				i += 1
				already_talked += 1
				return npc.npcName + ": \"" + dialogue + "\"" 
			elif i >= npc.dialogue.size():
				return npc.npcName + ": \"" + npc.dialogue.back() + "\""
	
	if words == "talk" && combat.combatInitiated == true:
		for npc in current_room.npcs:
			emit_signal("npc_talk", npc)
			if i < npc.dialogue.size():
				var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.dialogue[i]
				i += 1
				already_talked += 1
				return npc.npcName + ": \"" + dialogue + "\"" 
			elif i >= npc.dialogue.size():
				return npc.npcName + ": \"" + npc.dialogue.back() + "\""
	
	for npc in current_room.npcs:
		if words.contains(npc.npcName.to_lower()):
			emit_signal("npc_talk", npc)
			if i < npc.dialogue.size():
				var dialogue = npc.postQuestDialogue if npc.questItemReceived else npc.dialogue[i]
				i += 1
				already_talked += 1
				return npc.npcName + ": \"" + dialogue + "\"" 
			elif i >= npc.dialogue.size():
				return npc.npcName + ": \"" + npc.dialogue.back() + "\""
	return "%s is not currently in this room!" % words[1]

func cast(words):
	if words == "cast" && combat.combatInitiated == true:
		for npc in current_room.npcs:
				if words.contains(npc.npcName.to_lower()):
					return combat.spell(npc, player, player.equipped_items["Spell"])
	
	if !player.status_effects["Dread"]:
		for npc in current_room.npcs:
			if combat.combatInitiated:
				if words.contains("cast"):
					return combat.spell(npc, player, player.equipped_items["Spell"])
			else:
				return "You must be in combat to do that!"
	else:
		return "You are too afraid to cast!"
		
	return "That character is not here to attack!"

func run(_words):
	if combat.combatInitiated:
		return combat.run()
	else:
		return "You have nothing to run from!"

func journal(words):
	if words == "journal":
		return player.get_journal()
	else:
		for entry in player.journal:
			if words.contains(entry.journal_name.to_lower()):
				return entry.journal_entry
	return "Journal entry not found!"

func save(_words):
	if !combat.combatInitiated && current_room.is_checkpoint:
		emit_signal("save_game")
		return "Game saved!"
	else:
		return "You cannot rest here!"

func loadgame(_words):
	if current_room == null && !characterSelect.visible:
		emit_signal("load_game")
		var output = changeRoom(current_room)
		return "Loading game...(if it doesnt work automatically then you have no current save!)" + "\n" + "\n" + output
	else:
		return "You must be in the main menu to do that!"

func quitGame(_words):
		emit_signal("quit")
		return "Quit game"
