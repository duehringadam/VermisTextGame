extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#level variables
	var level_crypt = $"Isolated Crypt"
	var level_graveyard = $Graveyard
	var level_burial_grounds = $"High Burial Grounds"
	var level_deep_graveyard = $"Deep Graveyard"
	var level_catacombs = $"Pauper's Catacombs"
	var level_burial_room = $"Burial Room"
	var level_side_room = $"Side room"
	var level_catacombs_hallway = $"Catacombs Hallway"
	var level_catacombs_exit = $"Catacombs Exit"
	var level_hidden_chambers = $"Hidden Chambers"
	var level_catacombs_intersection = $"Catacombs Intersection"
	var level_silver_swamps_outskirts = $"Silver Swamp Outskirts"
	var level_the_silver_swamp = $"The Silver Swamp"
	var level_smoke_and_shadows = $"Smoke and Shadows"
	
	#instantiate items
	var gravestones = loadInspect("Gravestones")
	var crypt = loadInspect("crypt")
	#Crypt
	level_crypt.connectExitUnlocked("outside", level_graveyard,"inside")
	level_crypt.addInspect(crypt)
	
	#Graveyard
	level_graveyard.connectExitUnlocked("east",level_deep_graveyard,"back")
	level_graveyard.connectExitUnlocked("north",level_burial_grounds)
	level_graveyard.addInspect(gravestones)
	
	#Deep Graveyard
	var sword = loadInspect("Sword")
	var itemSword = loadItem("Weapons/Sword")
	var crazyBones = loadEnemy("crazy bones")
	level_deep_graveyard.addNPC(crazyBones)
	level_deep_graveyard.addInspect(sword)
	level_deep_graveyard.addItem(itemSword)
	
	#High Burial Grounds
	var tombs = loadInspect("tombs")
	var lonelyKnight = loadNPC("Lonely_Knight")
	#multiple words for a secret entrance
	level_burial_grounds.connectExitSecret("catacombs",level_catacombs,"outside")
	level_burial_grounds.connectExitSecret("inside",level_catacombs,"outside")
	level_burial_grounds.connectExitSecret("tomb",level_catacombs,"outside")
	level_burial_grounds.addInspect(tombs)
	level_burial_grounds.addNPC(lonelyKnight)
	
	#Catacombs
	level_catacombs.connectExitUnlocked("left",level_burial_room,"back")
	var skull = loadItem("Key/Skull")
	level_burial_room.addItem(skull)
	level_catacombs.connectExitUnlocked("right",level_side_room,"back")
	level_catacombs.connectExitUnlocked("forward",level_catacombs_intersection,"back")
	var bones = loadInspect("bones")
	level_catacombs.addInspect(bones)
	var sculptures = loadInspect("sculptures")
	var skeleton_sculpture = loadEnemy("Sculpture")
	var mushroom = loadItem("Misc/Catacomb Mushroom")
	level_side_room.addItem(mushroom)
	level_side_room.addInspect(sculptures)
	level_side_room.addNPC(skeleton_sculpture)
	var statue = loadInspect("statue")
	level_catacombs_intersection.addInspect(statue)
	level_catacombs_intersection.connectExitUnlocked("left",level_catacombs_hallway,"back")
	var secret = level_catacombs_intersection.connectExitSecretLocked("inside",level_hidden_chambers,"back")
	var battle_axe = loadItem("Weapons/battle-axe")
	level_hidden_chambers.addItem(battle_axe)
	skull.useValue = secret
	var frogKnight = loadNPC("frogKnight")
	var stenchChampion = loadEnemy("Stench_Champion")
	level_catacombs_exit.addNPC(stenchChampion)
	level_catacombs_hallway.addNPC(frogKnight)
	level_catacombs_hallway.connectExitUnlocked("forward",level_catacombs_exit)
	
	#silver swamps
	level_catacombs_exit.connectExitUnlocked("outside", level_silver_swamps_outskirts, "back")
	var drowsy_knight = loadNPC("drowsy knight")
	level_silver_swamps_outskirts.addNPC(drowsy_knight)
	#var mushroom = loadItem("Misc/Mushroom")
	level_silver_swamps_outskirts.connectExitUnlocked("forward", level_the_silver_swamp, "back")
	level_the_silver_swamp.connectExitUnlocked("forward", level_smoke_and_shadows)
	level_the_silver_swamp.connectExitUnlocked("left", level_smoke_and_shadows, "back")
	level_the_silver_swamp.connectExitUnlocked("right", level_smoke_and_shadows, "back")
	#endless level
	level_smoke_and_shadows.connectExitUnlocked("forward", level_smoke_and_shadows, "back")
	level_smoke_and_shadows.connectExitUnlocked("left", level_smoke_and_shadows, "back")
	level_smoke_and_shadows.connectExitUnlocked("right", level_smoke_and_shadows, "back")
	level_smoke_and_shadows.connectExitUnlocked("back", level_smoke_and_shadows, "back")
	

func loadItem(itemName: String):
	return load("res://items/" + itemName + ".tres")

func loadInspect(inspectName: String):
	return load("res://Inspectables/" + inspectName + ".tres")

func loadNPC(npcName: String):
	return load("res://npcs/" + npcName + ".tres")

func loadEnemy(npcName:String):
	return load("res://npcs/Enemies/" + npcName + ".tres")

func add_random_npc():
	var floating_visage = loadEnemy("Emerging Visage")
	$"Smoke and Shadows".addNPC(floating_visage)

func add_paladin():
	var paladin =  loadEnemy("Lost Paladin")
	$"Smoke and Shadows".addNPC(paladin)

func _on_player_player_asleep() -> void:
	$"Smoke and Shadows".connectExitUnlocked("forward", $"The Dream")
	var aspect_dream = loadEnemy("Aspect of the Dream")
	$"The Dream".addNPC(aspect_dream)
