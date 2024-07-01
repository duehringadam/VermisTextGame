extends TextureRect



func _on_command_processor_room_changed(new_room: Variant) -> void:
	self.texture = new_room.areaPicture
