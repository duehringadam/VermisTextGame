extends AudioStreamPlayer



func change_music(new_room):
	if new_room.music != null && self.playing != true:
		self.stream = new_room.music
		self.play()
		
func battle_music(stream):
	if stream != null:
		self.stream = stream
		self.play()
