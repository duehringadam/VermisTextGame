extends Resource


class_name NPC
#npc variables
@export var npcName: String = "NPC name"
@export_multiline var dialogue: Array[String] = []
@export_multiline var postQuestDialogue: String
@export var health := 1
#quest variables
@export var questItem: Resource
@export var npcDamage:= 1
@export var icon: Texture2D
@export var music = AudioStream
@export var statusEffect = ""
@export var isEnemy = false
var questItemReceived := false
var questReward = null

