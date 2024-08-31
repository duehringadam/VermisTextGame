extends HBoxContainer

@onready var stat_number = %statNumber
@onready var increase = $statIncrease
@onready var decrease = $statDecrease

var stat_minimum
var stat_max = 10
var stat

signal stat_increased
signal stat_decreased

func _ready() -> void:
	stat = int(stat_number.text)
	
	
func _process(delta: float) -> void:
	if stat == stat_minimum:
		self.decrease.disabled = true
	else:
		self.decrease.disabled = false
	if stat >= stat_max:
		self.increase.disabled = true
	else:
		self.increase.disabled = false

func _on_stat_increase_pressed() -> void:
	AudioManager.play_sound(load("res://sounds/SFX/click.wav"))
	stat = int(stat_number.text)
	stat += 1
	stat_number.text = str(stat)
	emit_signal("stat_increased")


func _on_stat_decrease_pressed() -> void:
	AudioManager.play_sound(load("res://sounds/SFX/click.wav"))
	stat = int(stat_number.text)
	stat -= 1
	stat_number.text = str(stat)
	emit_signal("stat_decreased")


func _on_level_up_stats_minimum(stats_array: Variant) -> void:
	stat = int(stat_number.text)
	stat_minimum = stat
