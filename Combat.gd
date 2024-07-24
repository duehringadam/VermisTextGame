extends Node

@onready var battle_music = $"../room music"
@onready var gameInfo = $"../Game Scene/Background/MarginContainer/Columns/rows/columns/gameInfo"
@onready var playerInput = $"../Game Scene/Background/MarginContainer/Columns/rows/inputArea/inputHbox/input"
@onready var areaPicture = $"../Game Scene/Background/MarginContainer/Columns/rows/visualArea/HBoxContainer/areaPicture"
@onready var commandProcessor = $"../CommandProcessor"
@onready var timer = $Timer


var player = null
var enemy = null
var combatInitiated = false

func initialize(enemy, player) -> String:
	battle_music.battle_music(enemy.music)
	self.enemy = enemy
	self.player = player
	changePicture()
	return "%s draws near..." % [enemy.npcName] + player_turn()

func player_turn() -> String:
	combatInitiated = true
	playerInput.editable = true
	return "
	Actions:
		Attack
		Run
		Talk"
	
func enemy_turn(enemy, player):
	combatInitiated = true
	
	player.player_stats["Health"] -= enemy.npcDamage
	
	if enemy.statusEffect != "":
		combatInflictStatus(enemy.statusEffect,player)
	
	if player.player_stats["Health"] <= 0:
		combatInitiated = false
		gameInfo.handleResponse("%s kills you with %s damage!" % [enemy.npcName, enemy.npcDamage])
	else:
		if enemy.npcDamage == 0:
			gameInfo.handleResponse("%s missed!" % [enemy.npcName] + player_turn())
		else:
			gameInfo.handleResponse("%s hits you for %s damage!" % [enemy.npcName, enemy.npcDamage] + player_turn()) 
	
func attack(enemy, player) -> String:
	combatInitiated = true
	enemy.health -= player.player_stats["Damage"]
	if player.status_effects["Slumber"] == true:
		playerInput.editable = false
		timer.start()
		return "You are asleep!"
	if enemy.health <= 0:
		combatInitiated = false
		areaPicture.texture = commandProcessor.current_room.areaPicture
		return "You kill %s!" % [enemy.npcName] 
	else:
		timer.start()
		playerInput.editable = false
		return "You hit %s for %s damage!" % [enemy.npcName, player.player_stats["Damage"]]
	
func run() -> String:
	if player.status_effects["Slumber"] == true:
		playerInput.editable = false
		timer.start()
		return "You are asleep!"
	combatInitiated = false
	areaPicture.texture = commandProcessor.current_room.areaPicture
	return "You run away cowardly."
	
func changePicture():
	if enemy.icon != null:
		areaPicture.texture = enemy.icon


func _on_timer_timeout() -> void:
	enemy_turn(enemy,player)
	
func combatInflictStatus(status: String, player):
	player.inflictStatus(status)
