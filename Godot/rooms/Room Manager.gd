extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#instantiate items
	var key = loadItem("houseKey")
	var gravestones = loadInspect("Gravestones")
	var sword = loadInspect("Sword")
	
	#Crypt
	$Crypt.connectExitUnlocked("outside", $Graveyard,"inside")
	$Crypt.addItem(key)
	
	#Graveyard
	#var exit = 
	#key.useValue = exit
	$Graveyard.connectExitUnlocked("east",$"Deep Graveyard","back")
	$Graveyard.connectExitUnlocked("north",$"High Burial Grounds")
	$Graveyard.addInspect(gravestones)
	#add npc to house
	
	#Deep Graveyard
	$"Deep Graveyard".addInspect(sword)
	
	#exit = $House.connectExitLocked("inside",$Barn,"house")
	#houseResident.questReward = exit
	$"High Burial Grounds".connectExitUnlocked("inside",$Catacombs,"outside")
	$Catacombs.connectExitUnlocked("left",$Catacombs_rm_1,"back")
	$Catacombs.connectExitUnlocked("right",$Catacombs_rm_2,"back")
	$Catacombs.connectExitUnlocked("forward",$"Catacombs Intersection","back")
	$"Catacombs Intersection".connectExitUnlocked("left",$"Catacombs_rm_3","back")
	var frogKnight = loadNPC("frogKnight")
	$"Catacombs_rm_3".addNPC(frogKnight)

func loadMusic(musicName: String):
	return load("res://sounds/" + musicName + ".mp3")

func loadItem(itemName: String):
	return load("res://items/" + itemName + ".tres")

func loadInspect(inspectName: String):
	return load("res://Inspectables/" + inspectName + ".tres")

func loadNPC(npcName: String):
	return load("res://npcs/" + npcName + ".tres")

