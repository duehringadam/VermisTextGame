extends Node

@onready var battle_music = $"../room music"
@onready var gameInfo = $"../Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo"
@onready var playerInput = $"../Game Scene/Background/MarginContainer/Columns/rows/inputArea/inputHbox/input"
@onready var areaPicture = $"../Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/areaPicture"
@onready var commandProcessor = $"../CommandProcessor"
@onready var timer = $Timer
@onready var current_room

signal player_attack
signal enemy_attack

var player = null
var enemy = null
var combatInitiated = false

func initialize(enemy, player) -> String:
	combatInitiated = true
	enemy.inCombat = true
	current_room = commandProcessor.current_room
	if enemy.music != null:
		battle_music.battle_music(enemy.music)
	self.enemy = enemy
	self.player = player
	changePicture()
	return "%s draws near..." % [enemy.npcName] + player_turn()

func equipItem(item) -> String:
	playerInput.editable = true
	timer.start()
	return "%s equipped!" % [item.itemName]

func player_turn() -> String:
	combatInitiated = true
	playerInput.editable = true
	return "
	Actions:
	Attack
	Cast
	Inspect
	Talk
	Run"
	
func enemy_turn(enemy, player):
	#print(enemy.health)
	gameInfo.handleResponse(enemy_turn_beginning())
	AudioManager.play_sound(load("res://sounds/SFX/playerHurt.wav"))
	combatInitiated = true
	return check_chance_attack(enemy, player)
	
func attack(enemy, player) -> String:
	combatInitiated = true
	return chance_attack_player(enemy, player)
	
func spell(enemy,player,spell) -> String:
	combatInitiated = true
	if player.status_effects["Slumber"] == true:
		playerInput.editable = false
		timer.start()
		return "You are asleep!"
	else:
		if player.equipped_items["Spell"] != null:
			enemy.inflictStatus(spell.spell_status_effect)
			enemy.health -= spell.spell_damage
			if enemy.health <= 0:
				AudioManager.play_sound(load("res://sounds/SFX/hitHurt.wav"))
				current_room.removeNPC(enemy)
				dropLoot(enemy)
				endCombat()
				areaPicture.texture = commandProcessor.current_room.areaPicture
				return "You kill %s!" % [enemy.npcName] 
			else:
				AudioManager.play_sound(load("res://sounds/SFX/hitHurt.wav"))
				enemy.inflictStatus(spell.spell_status_effect)
				timer.start()
				playerInput.editable = false
				return "You cast %s on %s for %s damage!" % [spell.itemName, enemy.npcName, spell.spell_damage] + "\nYou inflict %s with %s" % [enemy.npcName, spell.spell_status_effect]
		else:
			playerInput.editable = false
			timer.start()
			return "No spell equipped!"

func run() -> String:
	if player.status_effects["Slumber"] == true:
		playerInput.editable = false
		timer.start()
		return "You are asleep!"
	if enemy.isBoss:
		timer.start()
		return "You cannot run!"
	endCombat()
	areaPicture.texture = commandProcessor.current_room.areaPicture
	return "You run away cowardly."
	
func changePicture():
	if enemy.icon != null:
		areaPicture.texture = enemy.icon

func _on_timer_timeout() -> void:
	enemy_turn(enemy,player)
	
func combatInflictStatus(status: String, player):
	player.inflictStatus(status)

func endCombat():
	enemy.inCombat = false
	combatInitiated = false
	if player.player_stats["Health"] <= 0:
		pass
	else:
		battle_music.reset_music()

func dropLoot(enemy):
	for i in enemy.loot_table:
		current_room.addItem(i)

func enemy_turn_beginning():
	return enemy.checkStatus()

func check_chance_attack(enemy, player):
	var overall_chance: int = 0
	overall_chance += enemy.chance_to_hit
	var offset: int = 0
	var random_number = randi_range(0,100)
	
	if enemy.status_effects["Petrification"] or enemy.status_effects["Slumber"]:
		gameInfo.handleResponse("%s cannot attack!" % [enemy.npcName] + "\n" + player_turn())
	else:
		if random_number < enemy.chance_to_hit + offset:
			player.player_stats["Health"] -= enemy.npcDamage
			emit_signal("enemy_attack") 
			gameInfo.handleResponse("%s hits you for %s damage!" % [enemy.npcName, enemy.npcDamage] + player_turn())
			if enemy.statusEffect != "":
				check_chance_status(enemy)
			if player.player_stats["Health"] <= 0:
				emit_signal("enemy_attack") 
				endCombat()
				gameInfo.handleResponse("%s kills you with %s damage!" % [enemy.npcName, enemy.npcDamage]) 
		else:
				offset += enemy.chance_to_hit
				gameInfo.handleResponse("%s missed!" % [enemy.npcName] + player_turn())

func check_chance_status(enemy):
	var overall_chance: int = 0
	overall_chance += enemy.chance_to_hit
	var offset: int = 0
	var random_number = randi_range(0,100)
	
	if random_number < enemy.chance_to_apply_status + offset:
			if enemy.statusEffect != "":
				combatInflictStatus(enemy.statusEffect,player)
	else:
		offset += enemy.chance_to_hit
	
func chance_attack_player(enemy, player):
	var overall_chance: int = 0
	overall_chance += player.chance_to_hit
	var offset: int = 0
	var random_number = randi_range(0,100)
	
	if player.status_effects["Slumber"] == true:
		playerInput.editable = false
		timer.start()
		return "You are asleep!"
	if random_number < player.chance_to_hit + offset:
		enemy.health -= player.player_stats["Damage"]
		if enemy.health <= 0:
			emit_signal("player_attack")
			AudioManager.play_sound(load("res://sounds/SFX/hitHurt.wav"))
			current_room.removeNPC(enemy)
			dropLoot(enemy)
			endCombat()
			areaPicture.texture = commandProcessor.current_room.areaPicture
			return "You kill %s!" % [enemy.npcName] 
		else:
			emit_signal("player_attack")
			timer.start()
			AudioManager.play_sound(load("res://sounds/SFX/hitHurt.wav"))
			playerInput.editable = false
			return "You hit %s for %s damage!" % [enemy.npcName, player.player_stats["Damage"]]
	else:
		timer.start()
		playerInput.editable = false
		AudioManager.play_sound(load("res://sounds/SFX/hitHurt.wav"))
		offset += player.chance_to_hit
		return "You missed!"
