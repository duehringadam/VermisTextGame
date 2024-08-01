extends Resource

class_name NPC
#npc variables
var iterator = 0
var inCombat = false
var isDead = false

@export var status_effects = {
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
var stored_chance_to_hit: int
@export var chance_to_hit: int
@export var npcName: String = "NPC name"
@export_multiline var npcDescription: String = "NPC Description"
@export_multiline var dialogue: Array[String] = []
@export_multiline var postQuestDialogue: String
@export var health := 1
#quest variables
@export var questItem: Resource
@export var npcDamage:= 1
@export var icon: Texture2D
@export var music: AudioStream = null 
@export var statusEffect = ""
@export var isEnemy = false
@export var isBoss = false
@export var loot_table: Array[Item] = []
@export var chance_to_apply_status: int = 0
@export var isSecret = false

var questItemReceived := false
@export var questReward: Item

func _ready():
	stored_chance_to_hit = chance_to_hit

func _process():
	if health <= 0:
		isDead = true

func inflictStatus(status: String):
	match status:
		"Infection":
			status_effects["Infection"] = true
		"Dread":
			status_effects["Dread"] = true
		"Slumber":
			status_effects["Slumber"] = true
		"Petrification":
			status_effects["Petrification"] = true
		"Curse":
			status_effects["Curse"] = true
		"Insanity":
			status_effects["Insanity"] = true
		"Blindness":
			status_effects["Blindness"] = true
		"Posession":
			status_effects["Posession"] = true
		"White Hives":
			status_effects["White Hives"] = true
		_:
			pass

func Infection():
	if iterator < 2:
		health -= 1
		iterator += 1
		return "The infection spreads on %s!" % [npcName]
	else:
		iterator = 0
		status_effects["Infection"] = false
		return "The infection subsides on %s" % [npcName]
	

func Blindness():
	if iterator < 2:
		chance_to_hit = 1
		iterator += 1
		return "%s is blind!" % [npcName]
	else:
		chance_to_hit = stored_chance_to_hit
		iterator =0
		return "Sight returns to %s" % [npcName]
		
func Petrification():
	health = 0
	return "%s is petrified!" % [npcName]

func Slumber():
	if iterator < 2:
		iterator += 1
		return "%s is asleep!" % [npcName]
	else:
		iterator =0
		return "Conciousness returns to %s" % [npcName]

func checkStatus():
	for i in status_effects:
		if status_effects[i] == true:
			match i:
				"Infection":
					return Infection()
				"Blindness":
					return Blindness()
				"Petrification":
					return Petrification()
				"Slumber":
					return  Slumber()
		else:
			return ""
