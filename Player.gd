extends Node

var inventory: Array = []
var inventoryMax = 12
var inventoryHeld = 0
var player_dead = false
var check_death = true
var is_buffed = false
var combat_iterate = 0
var hazard_iterate_apply = 0
var room_iterate = 0
var experience = 0
var experience_total = 0
var level = 1
var experience_required = get_required_experience(level+1)

signal item_dropped(item)
signal item_equipped(equipped_items)
signal save_equipped(equipped_items)
signal stats_changed(player_stats)
signal starting_items_add(i)
signal dot_taken
signal player_asleep
signal item_unequipped(item)
signal journal_updated(journal)
signal level_up_screen
signal level_up_stats(stats)
signal experience_gained(growth_data)

@onready var areaPicture = $"../Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/areaPicture"
@onready var room_music = $"../room music"
@onready var game = $".."
@onready var playerInfo = $"../Game Scene/Background/MarginContainer/Columns/rows/columns/playerInfo"
var chance_to_hit = 0

var journal:Array = []

var tempjournal: Array = []

var equipped_items = {
	"Weapon": null,
	"Armor": null,
	"Jewelry": null,
	"Spell": null
}

var player_stats = {
	"Name": "",
	"Health": 1,
	"Max Health": 1,
	"Strength": 0,
	"Intelligence": 0,
	"Faith": 0,
	"Will": 0,
	"Damage": 1
}

var tempinventory: Array = []

var tempequipped = {"Weapon": null,
	"Armor": null,
	"Jewelry": null,
	"Spell": null
	}

func _ready():
	add_journal(load("res://Journal/lore journals/Greengrave journal.tres"))
	add_journal(load("res://Journal/lore journals/The Capital.tres"))

func _process(delta: float) -> void:
	if chance_to_hit > 100:
		chance_to_hit = 100
	if player_stats["Health"] <= 0 && check_death:
		check_death = false
		player_dead=true
		death()
	if player_stats["Health"] > player_stats["Max Health"]:
		player_stats["Health"] = player_stats["Max Health"]
	emit_signal("stats_changed", player_stats)
	chance_to_hit = (player_stats["Strength"] + player_stats["Will"]) * 12
	

func character_select(character: Resource):
	tempinventory.clear()
	player_stats = character.player_stats
	for i in character.starting_items.values():
		tempinventory.append(i)
		#print(tempinventory)
	for i in character.journal:
		tempjournal.append(i)
	
func death():
	if player_dead == true:
		#remove previous text after death
		room_music.death_music(load("res://sounds/Music/player_death.mp3"))
		AudioManager.play_sound(load("res://sounds/SFX/death.wav"))
		#change contextual picture to death screen
		areaPicture.texture = load("res://area_pictures/Death Screen.png")
		var max_lines_remembered = 0
		var rows_to_forget = game.historyrows.get_child_count() - max_lines_remembered
		for _i in range(rows_to_forget):
			game.historyrows.get_child(_i).queue_free()
		#add death text to game	
		game.gameInfo.handleResponse("You have died!") 
		game.gameInfo.handleResponse("You can quit by clicking the button on the bottom of the screen.")
		player_dead = false
		game.playerInput.editable = false
	
var immunity = {
	"Infection" = false,
	"Dread" = false,
	"Slumber" = false, 
	"Petrification" = false, 
	"Curse" = false, 
	"Insanity" = false, 
	"Blindness" = false, 
	"Possession" = false, 
	"White Hives" = false 
}

var status_effects = {
	"Infection" = false, #damage over time
	"Dread" = false, #player cannot attack
	"Slumber" = false, #puts character to sleep for a time
	"Petrification" = false, #instant death
	"Curse" = false, #will effect the players death at some point
	"Insanity" = false, #shaky text, cannot input commands for a time
	"Blindness" = false, #character loses room descriptions
	"Possession" = false, #attacks any npc they see maybe?
	"White Hives" = false #more potent damage over time
}

func inflictStatus(status: String):
	match status:
		"Infection":
			if immunity[status] == true:
				return
			else:
				if status_effects["Infection"] == true:
					return
				else:
					status_effects["Infection"] = true
					var timer = Timer.new()
					add_child(timer)
					timer.one_shot = false
					timer.wait_time = 45.0
					timer.timeout.connect(infection)
					timer.start()
		"Dread":
			if immunity[status] == true:
				return
			else:
				if status_effects["Dread"] == true:
					return
				else:
					status_effects["Dread"] = true
					var timer = Timer.new()
					add_child(timer)
					timer.one_shot = false
					timer.wait_time = 45.0
					timer.timeout.connect(endStatusEffect)
					timer.start()
		"Slumber":
			if immunity[status] == true:
				return
			else:
				if status_effects["Slumber"] == true:
					return
				else:
					status_effects["Slumber"] = true
					var timer = Timer.new()
					add_child(timer)
					timer.one_shot = false
					timer.wait_time = 45.0
					timer.timeout.connect(endStatusEffect)
					timer.start()
		"Petrification":
			if immunity[status] == true:
				return
			else:
				status_effects["Petrification"] = true
				player_stats["Health"] = 0
				player_dead = true
		"Curse":
			if immunity[status] == true:
				return
			else:
				if status_effects["Curse"] == true:
					return
				else:
					status_effects["Curse"] = true
		"Insanity":
			if immunity[status] == true:
				return
			else:
				if status_effects["Insanity"] == true:
					return
				else:
					status_effects["Insanity"] = true
					var timer = Timer.new()
					add_child(timer)
					timer.one_shot = true
					timer.wait_time = 45.0
					timer.timeout.connect(endStatusEffect)
					timer.start()
		"Blindness":
			if immunity[status] == true:
				return
			else:
				if status_effects["Blindness"] == true:
					return
				else:
					status_effects["Blindness"] = true
					var timer = Timer.new()
					add_child(timer)
					timer.one_shot = true
					timer.wait_time = 45.0
					timer.timeout.connect(endStatusEffect)
					timer.start()
		"Posession":
			if immunity[status] == true:
				return
			else:
				if status_effects["Posession"] == true:
					return
				else:
					status_effects["Posession"] = true
		"White Hives":
			if immunity[status] == true:
				return
			else:
				if status_effects["White Hives"] == true:
					return
				else:
					status_effects["White Hives"] = true
					var timer = Timer.new()
					add_child(timer)
					timer.one_shot = false
					timer.wait_time = 45.0
					timer.timeout.connect(infection)
					timer.start()
		_:
			return
	AudioManager.play_sound(load("res://sounds/SFX/status_inflicted.wav"))
	game.gameInfo.handleResponse("! You have been inflicted with " + status + "!")

func takeItem(item: Item):
	#print("Take Item!")
	if inventoryHeld < inventoryMax:
		inventory.append(item)
		inventoryHeld += 1
		AudioManager.play_sound(load("res://sounds/SFX/interface2.wav"))
	elif inventoryHeld >= inventoryMax:
		AudioManager.play_sound(load("res://sounds/SFX/action failed.wav"))
		return "You cannot carry anymore!"
	
func dropItem(item: Item):
	if item.isEquipped:
		return "You need to unequip the item first!"
	else:
		inventory.erase(item)
		if game.command_Processor.current_room == null:
			pass
		else:
			game.command_Processor.current_room.addItem(item)
		emit_signal("item_dropped", item)
		return "You drop the %s" % [item.itemName]
	
func unequipItem(item: Item):
	match item.itemType:
		Types.ItemTypes.ARMOR:
			if item.isEquipped == true:
				item.isEquipped = false
				player_stats["Max Health"] -= item.armor_Defense
				equipped_items["Armor"] = null
				AudioManager.play_sound(load("res://sounds/SFX/chainmail1.wav"))
				return "%s unequipped!" % [item.itemName]
			else:
				return "Nothing to unequip!"
		Types.ItemTypes.WEAPON:
			if player_stats["Name"] == "Mad Pricker" or player_stats["Name"] == "Rat Man":
				return "You cannot remove that which binds you."
			else:
				if item.isEquipped == true:
					item.isEquipped = false
					player_stats["Damage"] -= item.weapon_Damage
					equipped_items["Weapon"] = null
					emit_signal("item_unequipped", item)
					AudioManager.play_sound(load("res://sounds/SFX/sword-unsheathe.wav"))
					return "%s unequipped!" % [item.itemName]
				else: 
					return "Nothing to unequip!"
		Types.ItemTypes.JEWELRY:
			if item.isEquipped == true:
				item.isEquipped = false
				equipped_items["Jewelry"] = null
				AudioManager.play_sound(load("res://sounds/SFX/metal-small1.wav"))
				return "%s unequipped!" % [item.itemName]
			else:
				return "Nothing to unequip!"
		Types.ItemTypes.SPELL:
			if item.isEquipped == true:
				item.isEquipped = false
				equipped_items["Spell"] = null
				AudioManager.play_sound(load("res://sounds/SFX/cloth.wav"))
				return "%s unequipped!" % [item.itemName]
			else:
				return "Nothing to unequip!"
		_:
			pass
	
func equipItem(item: Item):
	match item.itemType:
		Types.ItemTypes.WEAPON:
			if item.isEquipped == false:
				if equipped_items["Weapon"] == null:
					for i in item.required_Stats:
						if player_stats[i] >= item.required_Stats[i]:
							item.isEquipped = true
							#print(item.isEquipped)
							player_stats["Damage"] += item.weapon_Damage
							equipped_items["Weapon"] = item
							emit_signal("save_equipped",equipped_items)
							emit_signal("item_equipped", equipped_items["Weapon"])
							AudioManager.play_sound(load("res://sounds/SFX/sword-unsheathe.wav"))
							return "%s equipped." % [item.itemName]
						else: 
							return  "You do not meet the requirements to equip %s" % [item.itemName]
				else:
					return "You can only equip one weapon!"
			else:
				return "%s already equipped!" % [item.itemName]
		Types.ItemTypes.ARMOR:
			if item.isEquipped == false:
				if equipped_items["Armor"] == null:
					for i in item.required_Stats:
						if player_stats[i] >= item.required_Stats[i]:
							item.isEquipped = true
							player_stats["Max Health"] += item.armor_Defense
							equipped_items["Armor"] = item
							emit_signal("save_equipped",equipped_items)
							emit_signal("item_equipped", equipped_items["Armor"])
							AudioManager.play_sound(load("res://sounds/SFX/chainmail1.wav"))
							return "%s equipped." % [item.itemName]
						else:
							return"You do not meet the requirements to equip this!"
				else:
					return "You can only equip one armor set!"
			else:
				return "%s already equipped!" % [item.itemName]
		Types.ItemTypes.JEWELRY:
			if item.isEquipped == false:
				item.isEquipped = true
				equipped_items["Jewelry"] = item
				emit_signal("save_equipped",equipped_items)
				emit_signal("item_equipped", equipped_items["Jewelry"])
				AudioManager.play_sound(load("res://sounds/SFX/metal-small1.wav"))
				return "%s equipped." % [item.itemName]
		Types.ItemTypes.SPELL:
			if item.isEquipped == false:
				if equipped_items["Spell"] == null:
					for i in item.required_Stats:
						if player_stats[i] >= item.required_Stats[i]:
							item.isEquipped = true
							equipped_items["Spell"] = item
							emit_signal("save_equipped",equipped_items)
							emit_signal("item_equipped", equipped_items["Spell"])
							AudioManager.play_sound(load("res://sounds/SFX/cloth.wav"))
							return "%s equipped!" % [item.itemName]
						else: 
							return  "You do not meet the requirements to equip %s!" % [item.itemName]
				else:
					return "You already have a spell equipped!"
			else:	
				return "You already have that equipped!"
		_:
			return "You cannot equip that!"

func getInventory() -> String:
	if inventory.size() == 0:
		return "Your inventory is empty!"
	
	var itemString = ""
	for item in inventory:
		itemString += item.itemName + ", "
	return "Inventory: " + itemString
	
func endStatusEffect():
	AudioManager.play_sound(load("res://sounds/SFX/status_subsides.wav"))
	for i in status_effects:
		#print(i)
		if status_effects[i] == true:
			game.gameInfo.handleResponse(i + " status subsides...")
			#print(i)
			playerInfo.clearStatus()
			status_effects[i] = false
	
func infection():
	if combat_iterate < 2:
		if status_effects["Infection"]:
			emit_signal("dot_taken")
			AudioManager.play_sound(load("res://sounds/SFX/playerHurt.wav"))
			game.gameInfo.handleResponse("The infection spreads...")
			player_stats["Health"] -= 1
			combat_iterate += 1
	else:
		combat_iterate = 0
		endStatusEffect()

func blindness():
	pass

func petrification():
	pass

func slumber():
	pass

func dread():
	if combat_iterate < 2:
		combat_iterate += 1
		game.gameInfo.handleResponse("You are stricken with fear!")
	else:
		combat_iterate = 0
		endStatusEffect()

func whiteHives():
	if combat_iterate < 2:
		game.gameInfo.handleResponse("The hives spread...")
		player_stats["Health"] -= 2
		combat_iterate += 1
	else:
		combat_iterate = 0
		endStatusEffect()

func _on_command_processor_confirm_select() -> void:
	for i in tempinventory:
		takeItem(i)
		equipItem(i)
		emit_signal("starting_items_add", i)
		#print(i)
	for i in tempjournal:
		add_journal(i)


func _on_command_processor_room_changed(new_room: Variant) -> void:
	if new_room.room_hazard != null:
		hazard_iterate_apply +=1
		for status in new_room.room_hazard:
			if new_room.room_hazard[status] == true:
				if hazard_iterate_apply == 14:
					endImmunity(status)
					inflictStatus(status)
					hazard_iterate_apply = 0
	
	match new_room.roomName:
		"Smoke and Shadows":
			room_iterate +=1
			if status_effects["Slumber"]:
				for i in range(game.gameInfo.history_rows.get_child_count()):
					game.gameInfo.history_rows.get_child(i).queue_free()
				game.gameInfo.handleResponse("[wave amp = 10.0 freq = 5.0 connected = 1]The mist swirls and churns unending...[/wave]")
				
				emit_signal("player_asleep")
				var boss_timer = Timer.new()
				add_child(boss_timer)
				boss_timer.one_shot = true
				boss_timer.wait_time = 6.0
				boss_timer.timeout.connect(sleep_boss_timer)
				boss_timer.start()
			if room_iterate == 2:
				game.gameInfo.handleResponse("[wave amp = 10.0 freq = 5.0 connected = 1]The mist swirls and churns unending...[/wave]")
			if room_iterate > 3:
				game.gameInfo.handleResponse("You struggle to stay concious...")
				game.command_Processor.current_room.roomDescription = "The mist swirls and churns unending..."
				game.room_manager.add_random_npc()
			if room_iterate == 9:
				game.room_manager.add_paladin()
			if room_iterate == 12:
				game.room_manager.add_floating_visage()
		_:
			pass

func updateImmunity(status):
	immunity[status] = true
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 90.0
	timer.timeout.connect(endImmunity.bind(status))
	timer.start()
	return "You gain immunity to %s!" % [status]

func endImmunity(status):
	game.gameInfo.handleResponse("Your immunity to %s ends..." % [status])
	immunity[status] = false

func sleep_boss_timer():
	endStatusEffect()
	game.gameInfo.handleResponse("A twisted figure emerges from the shadows...")
	game.command_Processor.current_room = $"../Room Manager/The Dream"
	game.gameInfo.handleResponse(game.command_Processor.changeRoom(game.command_Processor.current_room))
	chance_to_hit = 20
	#game.command_Processor.changeRoom(game.command_Processor.current_room)

func heal(heal_amount):
	return "You heal for %s health!" % [heal_amount]

func buff(item):
	if is_buffed == false:
		is_buffed = true
		var timer = Timer.new()
		add_child(timer)
		timer.one_shot = false
		timer.wait_time = 45.0
		timer.timeout.connect(endBuff.bind(item))
		timer.start()
		return "You frenzy!"
	else:
		return "You are already frenzied!"

func endBuff(item):
	is_buffed = false
	player_stats["Damage"] -= item.damage_increase
	game.gameInfo.handleResponse("Your frenzy ends...")

func _on_command_processor_quit() -> void:
	for i in equipped_items.values():
		if i != null:
			unequipItem(i)
			emit_signal("item_unequipped", i)
			emit_signal("item_dropped", i)
	inventory.clear()
	endStatusEffect()
	
func get_journal():
	if journal.size() == 0:
		return "Your journal is empty!"
	
	var journalString = ""
	for entry in journal:
		journalString += entry.journal_name + ", "
	return "Entries: " + journalString
	
func add_journal(entry):
	if entry != null:
		journal.append(entry)
		emit_signal("journal_updated",journal)
		return "You added entry: %s to your journal!" % [entry.journal_name]
	return ""
	
func updatePlayer():
	for i in status_effects:
		#print(i)
		if status_effects[i] == true:
			match i:
				"Infection":
					return infection()
				"Blindness":
					return blindness()
				"Petrification":
					return petrification()
				"Slumber":
					return slumber()
				"Dread":
					return dread()
	return ""

func get_required_experience(level):
	return round(pow(level,1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required,experience_required])
		level_up()
	growth_data.append([experience,experience_required])
	emit_signal("experience_gained",growth_data)

func level_up():
	level += 1
	experience_required = get_required_experience(level+1)
	emit_signal("level_up_screen")
	emit_signal("level_up_stats", player_stats)


func _on_level_up_stats_confirmed(stats: Variant) -> void:
	player_stats = stats
	player_stats["Max Health"] = stats["Health"]
