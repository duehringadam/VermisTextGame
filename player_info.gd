extends PanelContainer

@onready var statusIcon1 = $MarginContainer/VBoxContainer/GridContainer/statusEffectIcon
@onready var statusLabel = $MarginContainer/VBoxContainer/GridContainer/statusEffectsLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


func update_player(player):
	$MarginContainer/VBoxContainer/playerStats.text = str(player.player_stats["Name"])
	$MarginContainer/VBoxContainer/playerStats2.text = "Health: " +str(player.player_stats["Health"]) + "/"+str(player.player_stats["Max Health"])
	$MarginContainer/VBoxContainer/playerStats3.text = "Strength: " +str(player.player_stats["Strength"])
	$MarginContainer/VBoxContainer/playerStats4.text = "Intelligence: " +str(player.player_stats["Intelligence"])
	$MarginContainer/VBoxContainer/playerStats5.text = "Faith: " +str(player.player_stats["Faith"])
	$MarginContainer/VBoxContainer/playerStats6.text = "Will: " + str(player.player_stats["Will"])
	$MarginContainer/VBoxContainer/playerStats7.text = "Damage: " +str(player.player_stats["Damage"])
	
	for i in player.status_effects:
		if player.status_effects[i] == true:
			statusIcon1.texture = load("res://icons/" + i + ".png")
			statusLabel.text = "!" + i + "!"
		
func clearStatus():
	statusIcon1.texture = null
	statusLabel.text = ""
