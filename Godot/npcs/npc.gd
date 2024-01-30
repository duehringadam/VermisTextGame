extends Resource
class_name NPC
#npc variables
@export var npcName: String = "NPC name"
@export_multiline var initalDialogue: String
@export_multiline var postQuestDialogue: String
#quest variables
@export var questItem: Resource
var questItemReceived := false
var questReward = null
