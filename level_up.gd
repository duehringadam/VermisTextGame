extends PanelContainer

var level_up_points = 0
var stats
var level_points_max = 0

signal stats_confirmed(stats)
signal stats_minimum(stats_array)

@onready var health = %healthStats
@onready var strength = %strengthStats
@onready var intelligence = %intelligenceStats
@onready var faith = %faithStats
@onready var will = %willStats
@onready var points = %points
@onready var confirm_button = $"VBoxContainer/confirm button"

func _on_player_level_up_stats(player_stats: Variant) -> void:
	level_up_points += 1
	points.text = str(level_up_points)
	stats = player_stats
	
	health.stat_number.text = str(stats["Health"])
	strength.stat_number.text = str(stats["Strength"])
	intelligence.stat_number.text = str(stats["Intelligence"])
	faith.stat_number.text = str(stats["Faith"])
	will.stat_number.text = str(stats["Will"])
	
	level_points_max = level_up_points
	
	emit_signal("stats_minimum", stats)
	

func _process(delta: float) -> void:
	if level_up_points <= 0:
		health.increase.disabled = true
		strength.increase.disabled = true
		intelligence.increase.disabled = true
		faith.increase.disabled = true
		will.increase.disabled = true
		confirm_button.disabled = true
	else:
		health.increase.disabled = false
		strength.increase.disabled = false
		intelligence.increase.disabled = false
		faith.increase.disabled = false
		will.increase.disabled = false
		confirm_button.disabled = false
	
		

func _on_stat_increased() -> void:
	level_up_points -= 1
	points.text = str(level_up_points)


func _on_stat_decreased() -> void:
	level_up_points += 1
	points.text = str(level_up_points)


func _on_confirm_button_pressed() -> void:
	AudioManager.play_sound(load("res://sounds/SFX/click.wav"))
	stats["Health"] = int(health.stat_number.text)
	stats["Strength"] = int(strength.stat_number.text)
	stats["Intelligence"] = int(intelligence.stat_number.text)
	stats["Faith"] = int(faith.stat_number.text)
	stats["Will"] = int(will.stat_number.text)
	emit_signal("stats_confirmed", stats)
