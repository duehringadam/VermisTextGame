extends PanelContainer

signal close_settings_pass
signal crt_effect_toggled(toggled_on)
signal ambience_toggled(toggled_on)
signal font_size_changed(size)


func _on_close_settings_close_settings() -> void:
	emit_signal("close_settings_pass")
	


func _on_check_button_toggled(toggled_on: bool) -> void:
	emit_signal("crt_effect_toggled",toggled_on)
		


func _on_ambience_toggled(toggled_on: bool) -> void:
	emit_signal("ambience_toggled",toggled_on)


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			var size = 30
			emit_signal("font_size_changed", size)
		1:
			var size = 25
			emit_signal("font_size_changed", size)
		2:
			var size = 15
			emit_signal("font_size_changed", size)
