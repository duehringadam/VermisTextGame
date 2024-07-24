extends TextureRect



func _on_command_processor_room_changed(new_room: Variant) -> void:
	if new_room.areaPicture != null:
		self.texture = new_room.areaPicture
