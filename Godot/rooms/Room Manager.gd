extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#instantiate items
	var key = loadItem("houseKey")
	var bucket = loadItem("Bucket")
	
	#room 1
	$Field.connectExitUnlocked("north", $Field2)
	$Field.addItem(key)
	
	#room2
	#create exit and key useValue
	var exit = $Field2.connectExitLocked("inside",$House)
	key.useValue = exit
	#add npc to house
	var houseResident = loadNPC("houseResident")
	$House.addNPC(houseResident)
	exit = $House.connectExitLocked("inside",$Barn,"house")
	houseResident.questReward = exit
	
	#add exit to shed with override text
	$Field2.connectExitUnlocked("east",$Shed,"outside")
	#add npc to shed
	var shedResident = loadNPC("resident")
	$Shed.addNPC(shedResident)
	$Shed.addItem(bucket)
	
	
	
func loadItem(itemName: String):
	return load("res://items/" + itemName + ".tres")
	
func loadNPC(npcName: String):
	return load("res://npcs/" + npcName + ".tres")

